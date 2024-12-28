// 借鉴：https://github.com/elementary/pantheon-wayland
namespace ZwpTextInputV3 {
    [CCode (cheader_filename = "zwp_text_input_v3.h", cname = "struct zwp_text_input_manager_v3", cprefix = "zwp_text_input_manager_v3_")]
    public class Manager : Wl.Proxy {
        [CCode (cheader_filename = "zwp_text_input_v3.h", cname = "zwp_text_input_manager_v3_interface")]
        public static Wl.Interface iface;
        public void set_user_data (void* user_data);
        public void * get_user_data ();
        public uint32 get_version ();
        public void destroy ();
        public TextInput * get_text_input (Wl.Seat* seat);
    }
    [CCode (cheader_filename = "zwp_text_input_v3.h", cname = "struct zwp_text_input_v3", cprefix = "zwp_text_input_v3_")]
    public class TextInput : Wl.Proxy {
        [CCode (cheader_filename = "zwp_text_input_v3.h", cname = "zwp_text_input_v3_interface")]
        public static Wl.Interface iface;
        public void set_user_data (void* user_data);
        public void * get_user_data ();
        public uint32 get_version ();
        public void destroy ();
        public void enable ();
        public void disable ();
        public void set_surrounding_text (string text, int32 cursor, int32 anchor);
    }
}