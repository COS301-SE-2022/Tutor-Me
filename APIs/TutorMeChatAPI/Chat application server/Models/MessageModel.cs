using System;

namespace Chat_application_server.Models
{
    public class MessageModel
    {
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string MessageText { get; set; }
        public DateTime CreateDate { get; set; }
    }
}
