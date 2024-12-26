
public class Aikakim.App : Gtk.Application {
    public App () {
        Object (application_id: "com.github.humxc.aikakim");
    }

    public IMPanel panel = new IMPanel ();
    public InputMethod input_method = new InputMethod ();

    public override void activate () {
        hold ();
    }

    public static int main (string[] args) {
        var app = new Aikakim.App ();
        return app.run (args);
    }
}