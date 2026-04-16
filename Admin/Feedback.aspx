<%@ Page Title="User Feedback" Language="C#" MasterPageFile="~/Admin/Admin.master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="HimVeda.Admin.FeedbackPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .custom-grid { width: 100%; border-collapse: collapse; background: white; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); }
        .custom-grid th { background: #f8fafc; padding: 1.2rem; text-align: left; font-weight: 600; color: #475569; border-bottom: 2px solid #e2e8f0; }
        .custom-grid td { padding: 1rem 1.2rem; border-bottom: 1px solid #f1f5f9; color: #1e293b; }
        .rating-stars { color: #fbbf24; }
        
        .stat-card { background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 15px; margin-bottom: 2rem; border: 1px solid #f1f5f9; width: max-content; padding-right: 3rem;}
        .stat-icon { width: 50px; height: 50px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    
    <!-- Statistics -->
    <div class="stat-card">
        <div class="stat-icon" style="background:#e0e7ff; color:#4f46e5;"><i class="fa-solid fa-comment-dots"></i></div>
        <div>
            <h4 style="margin:0; color:#64748b; font-size:0.9rem;">Total Feedbacks</h4>
            <h2 style="margin:0; color:#1e293b; font-size:1.8rem;"><asp:Literal ID="litTotalFeedback" runat="server">0</asp:Literal></h2>
        </div>
    </div>

    <asp:GridView ID="gvFeedback" runat="server" AutoGenerateColumns="False" CssClass="custom-grid" GridLines="None" EmptyDataText="No feedback available right now.">
        <Columns>
            <asp:TemplateField HeaderText="S.N.">
                <ItemTemplate>
                    <%# Container.DataItemIndex + 1 %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="FullName" HeaderText="Customer" />
            <asp:BoundField DataField="ProductName" HeaderText="Product" />
            <asp:TemplateField HeaderText="Rating">
                <ItemTemplate>
                    <span class="rating-stars">
                        <%# GenerateStars(Eval("Rating")) %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Comment" HeaderText="Comment" />
            <asp:BoundField DataField="FeedbackDate" HeaderText="Date" DataFormatString="{0:MMM dd, yyyy}" />
        </Columns>
    </asp:GridView>
</asp:Content>
