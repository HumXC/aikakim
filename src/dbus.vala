
public class InputMethod : Object  {
    public signal void Enable (bool is_enable);
    public signal void ExecDialog (string dialog_name);
    public signal void ExecMenu (string[] menu_names);
    public signal void RegisterProperties (string[] property_names);
    public signal void RemoveProperty (string property_name);
    public signal void ShowAux (bool is_show);
    public signal void ShowLookupTable (bool is_show);
    public signal void ShowPreedit (bool is_show);
    public signal void UpdateAux (string aux_text, string aux_attr);
    public signal void UpdateLookupTableCursor (int cursor_pos);
    public signal void UpdatePreeditCaret (int caret_pos);
    public signal void UpdatePreeditText (string preedit_text, string preedit_attr);
    public signal void UpdateProperty (string property_name);
    public signal void UpdateScreen (int screen_id);
    public signal void UpdateSpotLocation (int x, int y);

    public InputMethod () {
        var conn = Bus.get_sync (GLib.BusType.SESSION, null);
        conn.signal_subscribe
            ("org.kde.kimpanel.inputmethod",
            null,
            null,
            "/kimpanel",
            null,
            GLib.DBusSignalFlags.NONE,
            handler);
    }

    private void handler (GLib.DBusConnection conn,
                          string? sender_name,
                          string object_path,
                          string interface_name,
                          string signal_name,
                          GLib.Variant parameters) {
        GLib.Variant value (int index) {
            return parameters.get_child_value (index);
        }

        switch (signal_name) {
        case "Enable":
            Enable (value (0).get_boolean ());
            break;
        case "ExecDialog":
            ExecDialog (value (0).get_string ());
            break;
        case "ExecMenu":
            var menu_names = value (0).get_strv ();
            ExecMenu (menu_names);
            break;
        case "RegisterProperties":
            var property_names = value (0).get_strv ();
            RegisterProperties (property_names);
            break;
        case "RemoveProperty":
            var property_name = value (0).get_string ();
            RemoveProperty (property_name);
            break;
        case "ShowAux":
            ShowAux (value (0).get_boolean ());
            break;
        case "ShowLookupTable":
            ShowLookupTable (value (0).get_boolean ());
            break;
        case "ShowPreedit":
            ShowPreedit (value (0).get_boolean ());
            break;
        case "UpdateAux":
            var aux_text = value (0).get_string ();
            var aux_attr = value (1).get_string ();
            UpdateAux (aux_text, aux_attr);
            break;
        case "UpdateLookupTableCursor":
            var cursor_pos = value (0).get_int32 ();
            UpdateLookupTableCursor (cursor_pos);
            break;
        case "UpdatePreeditCaret":
            var caret_pos = value (0).get_int32 ();
            UpdatePreeditCaret (caret_pos);
            break;
        case "UpdatePreeditText":
            var preedit_text = value (0).get_string ();
            var preedit_attr = value (1).get_string ();
            UpdatePreeditText (preedit_text, preedit_attr);
            break;
        case "UpdateProperty":
            var property_name = value (0).get_string ();
            UpdateProperty (property_name);
            break;
        case "UpdateScreen":
            var screen_id = value (0).get_int32 ();
            UpdateScreen (screen_id);
            break;
        case "UpdateSpotLocation":
            var x = value (0).get_int32 ();
            var y = value (1).get_int32 ();
            UpdateSpotLocation (x, y);
            break;
        }
    }
}

[DBus (name = "org.kde.impanel")]
public interface Kimpanel : Object  {
    public signal void MovePreeditCaret (int position);
    public signal void SelectCandidate (int index);
    public signal void LookupTablePageUp ();
    public signal void LookupTablePageDown ();
    public signal void TriggerProperty (string key);
    public signal void PanelCreated ();
    public signal void Exit ();
    public signal void ReloadConfig ();
    public signal void Configure ();
}

[DBus (name = "org.kde.impanel2")]
public interface Kimpanel2 : Object  {
    public signal void PanelCreated2 ();
    public abstract void SetSpotRect (int x, int y, int w, int h);
    public abstract void SetRelativeSpotRect (int x, int y, int w, int h);
    public abstract void SetRelativeSpotRectV2 (int x, int y, int w, int h, double scale);
    public abstract void SetLookupTable (string[] label, string[] text, string[] attr, bool hasPrev, bool hasNext, int cursor, int layout);
}
public void RegisterPanel (IMPanel panel) {
    Bus.own_name
        (GLib.BusType.SESSION,
        "org.kde.impanel",
        GLib.BusNameOwnerFlags.NONE,
        (conn) => {
        try {
            conn.register_object ("/org/kde/impanel", (Kimpanel) panel);
            conn.register_object ("/org/kde/impanel", (Kimpanel2) panel);
        } catch (IOError e) {
            stderr.printf ("Could not register service\n");
        }
    },
        () => {
        panel.PanelCreated ();
        panel.PanelCreated2 ();
    },
        () => stderr.printf ("Could not aquire name\n"));
}

public interface IMPanel : Kimpanel, Kimpanel2 {}