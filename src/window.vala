
[GtkTemplate (ui = "/com/github/humxc/aikakim/ui/window.ui")]
public class Aikakim.Window : Gtk.Window, Kimpanel, Kimpanel2, IMPanel {
    private InputMethod im = new InputMethod ();
    public string aux { get; set; default = ""; }
    public bool aux_visible { get; set; default = false; }
    public bool lookup_table_visible { get; set; default = false; }
    public bool window_visible { get; set; default = false; }
    [GtkChild]
    public unowned Gtk.Box lookup_table_box;
    [GtkChild]
    public unowned Gtk.Box aux_box;
    private unowned ZwpTextInputV3.TextInput text_input;
    private string[] need_update_names = {
        "lookup-table-visible",
        "aux-visible",
        "window-visible",
        "aux"
    };
    construct {
        set_layer ();
        RegisterPanel ((IMPanel) this);
        im.ShowLookupTable.connect ((v) => {
            lookup_table_visible = v;
            window_visible = lookup_table_visible || aux_visible;
        });
        im.ShowAux.connect ((v) => {
            aux_visible = v;
            window_visible = lookup_table_visible || aux_visible;
        });
        im.UpdateAux.connect ((text, attr) => this.aux = text);
        notify.connect ((spec) => {
            foreach (string name in need_update_names) {
                if (spec.name == name) {
                    update_window ();
                    break;
                }
            }
        });
    }
    public Window () {

        var display = (Gdk.Wayland.Display) Gdk.Display.get_default ();
        unowned Wl.Seat seat = ((Gdk.Wayland.Seat) display.list_seats ().first ().data).get_wl_seat ();
        var data = Data () { seat = seat };

        unowned var d = display.get_wl_display ();
        var reg = d.get_registry ();
        reg.add_listener ({
            global:  (Wl.RegistryListenerGlobal) global,
        }, &data);
        d.dispatch ();
        print (data.text_input.get_class ());
        text_input = data.text_input;
        text_input.enable ();

        return;
    }

    public void update_window () {
        if (!window_visible)return;
        int w = -1;
        int h = -1;
        if (lookup_table_visible)
            lookup_table_box.get_size_request (out w, out h);
        if (aux_visible)
            aux_box.get_size_request (out w, out h);
        if (w == -1 || h == -1)return;
        set_size_request (w, h);
    }

    public void SetSpotRect (int x, int y, int w, int h) {
        set_position (x + w, y + h);
        print ("SetSpotRect: %d, %d, %d, %d\n", x, y, w, h);
    }

    public void SetRelativeSpotRect (int x, int y, int w, int h) {
        print ("SetRelativeSpotRect: %d, %d, %d, %d\n", x, y, w, h);
    }

    public void SetRelativeSpotRectV2 (int x, int y, int w, int h, double scale) {
        print ("SetRelativeSpotRectV2: %d, %d, %d, %d, %f\n", x, y, w, h, scale);
    }

    public void SetLookupTable (string[] label, string[] text, string[] attr, bool hasPrev, bool hasNext, int cursor, int layout) {
        return;
        for (int i = 0; i < label.length; i++) {
            print ("label: %s, text: %s, attr: %s\n", label[i], text[i], attr[i]);
        }
        print ("hasPrev: %b, hasNext: %b, cursor: %d, layout: %d \n", hasPrev, hasNext, cursor, layout);
    }

    private void set_layer () {
        GtkLayerShell.init_for_window (this);
        GtkLayerShell.set_keyboard_mode (this, GtkLayerShell.KeyboardMode.NONE);
        GtkLayerShell.set_layer (this, GtkLayerShell.Layer.OVERLAY);
        GtkLayerShell.set_exclusive_zone (this, -1);
        GtkLayerShell.set_anchor (this, GtkLayerShell.Edge.TOP, true);
        GtkLayerShell.set_anchor (this, GtkLayerShell.Edge.LEFT, true);
        GtkLayerShell.set_namespace (this, "aikakim");
    }

    private void set_position (int x, int y) {
        GtkLayerShell.set_margin (this, GtkLayerShell.Edge.LEFT, x);
        GtkLayerShell.set_margin (this, GtkLayerShell.Edge.TOP, y);
    }
}
private void global (void* data, Wl.Registry wl_registry, uint32 name, string @interface, uint32 version) {
    if (@interface != "zwp_text_input_manager_v3")return;
    var manager = wl_registry.bind<ZwpTextInputV3.Manager> (name, ref ZwpTextInputV3.Manager.iface, version);
    var d = (Data*) data;

    unowned var ipt = (ZwpTextInputV3.TextInput) manager.get_text_input (d.seat);
    d.text_input = ipt;
}

public struct Data {
    unowned Wl.Seat seat;
    unowned ZwpTextInputV3.TextInput text_input;
}