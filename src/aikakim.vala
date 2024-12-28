
public class Aikakim.App : Gtk.Application {
    public App () {
        Object (application_id: "com.github.humxc.aikakim");
    }

    public override void activate () {
        base.activate ();
        Gtk.CssProvider provider = new Gtk.CssProvider ();
        provider.load_from_resource ("/com/github/humxc/aikakim/style.css");
        Gtk.StyleContext.add_provider_for_display (
                                                   Gdk.Display.get_default (),
                                                   provider,
                                                   Gtk.STYLE_PROVIDER_PRIORITY_USER);

        var window = new Aikakim.Window ();
        this.add_window (window);
        hold ();
    }

    public static int main (string[] args) {
        ensure_types ();
        var app = new Aikakim.App ();
        return app.run (args);
    }
}