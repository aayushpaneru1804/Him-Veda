<%@ Page Title="Submit Feedback" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Feedback.aspx.cs" Inherits="HimVeda.FeedbackPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Product Feedback
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap');

        .feedback-page-wrapper { font-family: 'Poppins', sans-serif; background: #f8fafc; padding: 2rem; border-radius: 20px; box-shadow: inset 0 2px 20px rgba(0,0,0,0.02); }
        .feedback-header h2 { font-weight: 700; color: #1e293b; letter-spacing: -0.5px; }
        
        .feedback-card { background: #ffffff; padding: 1.8rem; margin-bottom: 1.5rem; border-radius: 14px; box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05); border: 1px solid rgba(0,0,0,0.03); transition: transform 0.2s; }
        .feedback-card:hover { transform: translateY(-3px); box-shadow: 0 15px 30px -5px rgba(0,0,0,0.08); }
        .feedback-label { font-weight: 600; color: #334155; font-size: 1.15rem; margin-bottom: 1.2rem; display: block; border-bottom: 2px solid #f1f5f9; padding-bottom: 0.5rem; }
        
        .star-rating { direction: rtl; display: inline-flex; font-size: 2.8rem; justify-content: center; width: 100%; margin-top: 0.5rem; }
        .star-rating input { display: none; }
        .star-rating label { color: #e2e8f0; cursor: pointer; padding: 0 0.2rem; transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1); }
        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label { color: #f59e0b; transform: scale(1.15); }
        
        .radio-list-horizontal table { margin: 0 auto; width: 100%; border-collapse: separate; border-spacing: 15px 0; }
        .radio-list-horizontal td { background: #f1f5f9; padding: 0.8rem 1.2rem; border-radius: 8px; text-align: center; cursor: pointer; transition: background 0.2s; }
        .radio-list-horizontal td:hover { background: #e2e8f0; }
        .radio-list-horizontal input[type="radio"] { margin-right: 0.5rem; transform: scale(1.2); accent-color: var(--primary-color); }
        .radio-list-horizontal label { font-weight: 500; color: #475569; font-size: 1rem; cursor: pointer; }
        
        .form-control-custom { width: 100%; border: 1.5px solid #cbd5e1; border-radius: 10px; padding: 1rem; font-family: inherit; font-size: 1rem; transition: border-color 0.3s; background: #fafafa; }
        .form-control-custom:focus { border-color: var(--primary-color); outline: none; background: white; box-shadow: 0 0 0 3px rgba(45,106,79,0.1); }
        
        .btn-submit-premium { background: linear-gradient(135deg, var(--primary-color), #204d39); color: white; border: none; padding: 1.2rem; border-radius: 10px; font-weight: 600; font-size: 1.2rem; font-family: 'Poppins', sans-serif; cursor: pointer; transition: all 0.3s; box-shadow: 0 10px 20px -5px rgba(32, 77, 57, 0.5); width: 100%; text-transform: uppercase; letter-spacing: 1px; }
        .btn-submit-premium:hover { transform: translateY(-3px); box-shadow: 0 15px 25px -5px rgba(32, 77, 57, 0.6); background: linear-gradient(135deg, #204d39, #153225); }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container mt-5 feedback-page-wrapper" style="max-width: 700px;">
        <div class="text-center mb-5 feedback-header">
            <h2>Your Feedback Matters</h2>
            <p class="text-muted" style="font-size: 1.1rem;">Tell us about your experience with <strong><asp:Literal ID="litProductName" runat="server"></asp:Literal></strong></p>
        </div>

        <asp:Label ID="lblMessage" runat="server" CssClass="alert alert-info text-center" Visible="false" style="display: block; margin-bottom: 2rem;"></asp:Label>

        <!-- Question 1: Service Satisfaction -->
        <div class="feedback-card">
            <label class="feedback-label">1. Are you satisfied with our services?</label>
            <asp:RadioButtonList ID="rdoListSatisfaction" runat="server" RepeatDirection="Horizontal" CssClass="radio-list-horizontal">
                <asp:ListItem Text="Very Satisfied" Value="Very Satisfied" />
                <asp:ListItem Text="Satisfied" Value="Satisfied" />
                <asp:ListItem Text="Neutral" Value="Neutral" />
                <asp:ListItem Text="Dissatisfied" Value="Dissatisfied" />
            </asp:RadioButtonList>
        </div>

        <!-- Question 2: Product Quality -->
        <div class="feedback-card">
            <label class="feedback-label">2. Are our products of high quality?</label>
            <asp:RadioButtonList ID="rdoListQuality" runat="server" RepeatDirection="Horizontal" CssClass="radio-list-horizontal">
                <asp:ListItem Text="Excellent" Value="Excellent" />
                <asp:ListItem Text="Good" Value="Good" />
                <asp:ListItem Text="Average" Value="Average" />
                <asp:ListItem Text="Poor" Value="Poor" />
            </asp:RadioButtonList>
        </div>

        <!-- Question 3: Recommendation -->
        <div class="feedback-card">
            <label class="feedback-label">3. Would you recommend us to a friend?</label>
            <asp:RadioButtonList ID="rdoListRecommend" runat="server" RepeatDirection="Horizontal" CssClass="radio-list-horizontal">
                <asp:ListItem Text="Definitely" Value="Definitely" />
                <asp:ListItem Text="Probably" Value="Probably" />
                <asp:ListItem Text="Not Sure" Value="Not Sure" />
                <asp:ListItem Text="Never" Value="Never" />
            </asp:RadioButtonList>
        </div>

        <!-- Detailed Feedback -->
        <div class="feedback-card">
            <label class="feedback-label">4. Any other suggestions?</label>
            <asp:TextBox ID="txtComment" runat="server" CssClass="form-control-custom" TextMode="MultiLine" Rows="4" placeholder="Tell us exactly what you loved or what went wrong..."></asp:TextBox>
        </div>

        <!-- Final Star Rating -->
        <div class="feedback-card text-center" style="background: linear-gradient(to right, #fffbeb, #ffffff); border-color: #f59e0b;">
            <label class="feedback-label" style="color: #d97706; text-align: center; border: none; font-size: 1.4rem; justify-content: center;">Overall Rating</label>
            <div class="star-rating">
                <asp:RadioButton ID="star5" runat="server" GroupName="rating" /> <label for="<%= star5.ClientID %>"><i class="fa-solid fa-star"></i></label>
                <asp:RadioButton ID="star4" runat="server" GroupName="rating" /> <label for="<%= star4.ClientID %>"><i class="fa-solid fa-star"></i></label>
                <asp:RadioButton ID="star3" runat="server" GroupName="rating" /> <label for="<%= star3.ClientID %>"><i class="fa-solid fa-star"></i></label>
                <asp:RadioButton ID="star2" runat="server" GroupName="rating" /> <label for="<%= star2.ClientID %>"><i class="fa-solid fa-star"></i></label>
                <asp:RadioButton ID="star1" runat="server" GroupName="rating" /> <label for="<%= star1.ClientID %>"><i class="fa-solid fa-star"></i></label>
            </div>
        </div>

        <asp:HiddenField ID="hiddenPID" runat="server" />
        <asp:HiddenField ID="hiddenOID" runat="server" />

        <div style="margin-top: 2rem;">
            <asp:Button ID="btnSubmit" runat="server" Text="Submit Feedback" CssClass="btn-submit-premium" OnClick="btnSubmit_Click" />
        </div>
        
        <div class="text-center" style="margin-top: 1.5rem;">
            <a href="OrderHistory.aspx" style="color: #94a3b8; text-decoration: none; font-weight: 500; transition: color 0.2s;" onmouseover="this.style.color='#475569'" onmouseout="this.style.color='#94a3b8'">← Cancel and go back</a>
        </div>
    </div>
</asp:Content>
