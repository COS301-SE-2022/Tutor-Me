using Microsoft.AspNetCore.SignalR;
using System;
using System.Threading.Tasks;
using Chat_application_server.Models;

namespace Chat_application_server.Hubs
{
    public class ChatHub : Hub
    {
        public async Task SendMessage(string UserName, string UserId, string Message)
        {
            MessageModel MessageModel = new MessageModel
            {
                CreateDate = DateTime.Now,
                MessageText = Message,
                UserId = UserId,
                UserName = UserName
            };
            await Clients.All.SendAsync("ReceiveMessage", MessageModel);
        }

        public async Task JoinUSer(string userName,string userId)
        {
            MessageModel MessageModel = new MessageModel
            {
                CreateDate = DateTime.Now,
                MessageText = userName + " joined chat",
                UserId = "0",
                UserName = "system"
            };
            await Clients.All.SendAsync("ReceiveMessage", MessageModel);
        }

        public Task JoinGroup(string groupName, string groupId, string userName,string userId)
        {
            MessageModel MessageModel = new MessageModel
            {
                CreateDate = DateTime.Now,
                MessageText = userName + " joined " + groupName,
                UserId = "0",
                UserName = "system"
            };
            Clients.Group(groupId).SendAsync("ReceiveMessage", MessageModel);

            return Groups.AddToGroupAsync(Context.ConnectionId, groupId);
        }

        public Task JoinChat(string receiverName, string userId, string receiverID , string userName)
        {
            MessageModel MessageModel = new MessageModel
            {
                CreateDate = DateTime.Now,
                MessageText = userName + " is online",
                UserId = "0",
                UserName = "system"
            };
            string groupId = "";
            if (String.Compare(userId, receiverID, StringComparison.Ordinal) < 0)
            {
                groupId = userId + receiverID;
            }
            else
            {
                groupId = receiverID + userId;
            }
            Clients.Group(groupId).SendAsync("ReceiveMessage", MessageModel);

            return Groups.AddToGroupAsync(Context.ConnectionId, groupId);
        }

        public Task SendMessageToChat(string userId, string receiverID, string UserName, string Message)
        {
            string groupId = "";
            if (String.Compare(userId, receiverID, StringComparison.Ordinal) < 0)
            {
                groupId = userId + receiverID;
            }
            else
            {
                groupId = receiverID + userId;
            }
            MessageModel MessageModel = new MessageModel
            {
                CreateDate = DateTime.Now,
                MessageText = Message,
                UserId = userId,
                UserName = UserName
            };
            return Clients.Group(groupId).SendAsync("ReceiveMessage", MessageModel);
        }
    
        public Task SendMessageToGroup(string groupId, string UserName, string UserId, string Message)
        {
            MessageModel MessageModel = new MessageModel
            {
                CreateDate = DateTime.Now,
                MessageText = Message,
                UserId = UserId,
                UserName = UserName
            };
            return Clients.Group(groupId).SendAsync("ReceiveMessage", MessageModel);
        }
    }
}