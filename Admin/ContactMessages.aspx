<%@ Page Title="Contact Messages" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="ContactMessages.aspx.cs" Inherits="HimVeda.Admin.ContactMessagesPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .custom-grid { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .custom-grid th { background: #f8fafc; padding: 1.2rem; text-align: left; font-weight: 600; color: #475569; border-bottom: 2px solid #e2e8f0; }
        .custom-grid td { padding: 1rem 1.2rem; border-bottom: 1px solid #f1f5f9; color: #1e293b; vertical-align: top; }
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 15px; margin-bottom: 2rem; border: 1px solid #f1f5f9; width: max-content; padding-right: 3rem;}
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
        .msg-box { max-width: 380px; white-space: pre-wrap; line-height: 1.45; }
        .detail-box { background: #f8fafc; border: 1px solid #e2e8f0; border-radius: 10px; padding: 0.75rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:Label ID="lblStatus" runat="server" Visible="false" style="display:block; margin-bottom:1rem; padding:0.8rem; border-radius:10px;"></asp:Label>
    <div class="stat-card">
        <div class="stat-icon" style="background:#ecfeff; color:#0e7490;"><i class="fa-solid fa-envelope-open-text"></i></div>
        <div>
            <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Contact Messages</h4>
            <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalMessages" runat="server">0</asp:Literal></h2>
        </div>
    </div>

    <asp:GridView ID="gvMessages" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None" EmptyDataText="No contact messages yet.">
        <Columns>
            <asp:TemplateField HeaderText="S.N.">
                <ItemTemplate><%# Container.DataItemIndex + 1 %></ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="FullName" HeaderText="Name" />
            <asp:BoundField DataField="Email" HeaderText="Email" />
            <asp:BoundField DataField="Phone" HeaderText="Phone" />
            <asp:BoundField DataField="Subject" HeaderText="Subject" />
            <asp:TemplateField HeaderText="Message Details">
                <ItemTemplate>
                    <div class="detail-box">
                        <div style="font-size:0.82rem; color:#64748b; margin-bottom:0.35rem;">Topic: <%# Eval("Subject") %></div>
                        <div class="msg-box"><%# Eval("Message") %></div>
                    </div>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="SubmittedAt" HeaderText="Submitted At" DataFormatString="{0:MMM dd, yyyy hh:mm tt}" />
        </Columns>
    </asp:GridView>
</asp:Content>
