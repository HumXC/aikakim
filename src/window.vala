
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

    public void on_enter (void* data, Wl.Pointer wl_pointer, uint32 serial, Wl.Surface surface, Wl.fixed_t surface_x, Wl.fixed_t surface_y) {
        print ("enter: %d, %d\n", surface_x, surface_y);
    }

    public void on_leave (void* data, Wl.Pointer wl_pointer, uint32 serial, Wl.Surface surface) {
        print ("leave\n");
    }

    public void on_motion (void* data, Wl.Pointer wl_pointer, uint32 time, Wl.fixed_t surface_x, Wl.fixed_t surface_y) {
        print ("motion: %d, %d\n", surface_x, surface_y);
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