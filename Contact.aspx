<%@ Page Title="Contact Us" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="HimVeda.ContactPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Contact Us
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .contact-page {
            max-width: 1180px;
            margin: 2rem auto 0;
        }
        .contact-hero {
            background: linear-gradient(135deg, #0f766e, #0ea5e9);
            color: #fff;
            border-radius: 18px;
            padding: 2rem;
            box-shadow: var(--shadow-lg);
            margin-bottom: 1.5rem;
        }
        .contact-hero h1 {
            color: #fff;
            margin-bottom: 0.5rem;
        }
        .mega-card {
            background: #ffffff;
            border: 1px solid #dbeafe;
            border-radius: 18px;
            box-shadow: var(--shadow-lg);
            padding: 1.25rem;
        }
        .contact-layout {
            display: grid;
            grid-template-columns: minmax(300px, 0.95fr) minmax(420px, 1.3fr);
            gap: 1.25rem;
            align-items: start;
        }
        .left-stack {
            display: grid;
            gap: 1.25rem;
        }
        .glass-card {
            background: #fff;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
            box-shadow: var(--shadow-md);
            padding: 1.25rem;
        }
        .glass-title {
            margin: 0 0 0.7rem 0;
            color: #0f172a;
            font-size: 1.2rem;
        }
        .meta-line {
            margin: 0.45rem 0;
            color: #475569;
        }
        .meta-line i {
            width: 20px;
            color: #0891b2;
        }
        .contact-btn {
            display: inline-block;
            margin-top: 0.8rem;
            text-decoration: none;
            background: #0ea5e9;
            color: #fff;
            padding: 0.65rem 1.05rem;
            border-radius: 10px;
            font-weight: 600;
        }
        .right-stack {
            display: grid;
            gap: 1.25rem;
        }
        .map-frame {
            width: 100%;
            height: 300px;
            border: 0;
            border-radius: 14px;
            display: block;
        }
        .fancy-form {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 0.9rem 1rem;
        }
        .fancy-form .full {
            grid-column: 1 / -1;
        }
        .fancy-input,
        .fancy-select,
        .fancy-textarea {
            width: 100%;
            box-sizing: border-box;
            border: 1px solid #cbd5e1;
            border-radius: 10px;
            padding: 0.72rem 0.8rem;
            font-size: 0.95rem;
            background: #fff;
        }
        .fancy-textarea {
            resize: vertical;
            min-height: 120px;
        }
        .submit-btn {
            border: none;
            background: linear-gradient(135deg, #0ea5e9, #2563eb);
            color: #fff;
            border-radius: 10px;
            padding: 0.75rem 1.25rem;
            font-weight: 700;
            cursor: pointer;
        }
        .helper-note {
            color: #64748b;
            font-size: 0.9rem;
            margin-top: 0.35rem;
        }
        @media (max-width: 980px) {
            .contact-layout { grid-template-columns: 1fr; }
        }
        @media (max-width: 640px) {
            .fancy-form { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container contact-page">
        <div class="contact-hero">
            <h1><i class="fa-solid fa-headset"></i> Contact HimVeda</h1>
            <p style="margin: 0; color: #e0f2fe;">Unique support experience for wellness buyers, partners, and vendors.</p>
        </div>

        <div class="mega-card">
            <div class="contact-layout">
                <!-- Left same column: Contact + Feedback -->
                <div class="left-stack">
                    <div class="glass-card">
                        <h3 class="glass-title"><i class="fa-solid fa-building"></i> Office Contact</h3>
                        <p class="meta-line"><i class="fa-solid fa-signature"></i> <strong>Office Name:</strong> HimVeda</p>
                        <p class="meta-line"><i class="fa-solid fa-location-dot"></i> <strong>Location:</strong> Sanu Complex</p>
                        <p class="meta-line"><i class="fa-solid fa-clock"></i> <strong>Support Status:</strong> Available 24/7</p>
                        <p class="meta-line"><i class="fa-solid fa-envelope"></i> support@himveda.com</p>
                        <p class="meta-line"><i class="fa-solid fa-phone"></i> +977 1234567890</p>
                    </div>

                    <div class="glass-card" style="background: linear-gradient(145deg, #f8fafc, #ecfeff);">
                        <h3 class="glass-title"><i class="fa-regular fa-comment-dots"></i> Feedback Corner</h3>
                        <p class="meta-line" style="margin-top: 0;">Your feedback helps us improve product quality, delivery, and service.</p>
                        <p class="helper-note">Want to send suggestion directly? Use Feedback page.</p>
                        <a href="Feedback.aspx" class="contact-btn">Open Feedback</a>
                    </div>
                </div>

                <!-- Right side: Map + Form -->
                <div class="right-stack">
                    <div class="glass-card">
                        <h3 class="glass-title"><i class="fa-solid fa-map-location-dot"></i> Office Map</h3>
                        <iframe
                            class="map-frame"
                            loading="lazy"
                            referrerpolicy="no-referrer-when-downgrade"
                            src="https://www.google.com/maps?q=Kathmandu&output=embed">
                        </iframe>
                    </div>

                    <div class="glass-card">
                        <h3 class="glass-title"><i class="fa-solid fa-paper-plane"></i> Submit Contact Form</h3>
                        <asp:Label ID="lblContactMessage" runat="server" Visible="false" style="display:block; margin-bottom:0.8rem; padding:0.75rem; border-radius:10px;"></asp:Label>
                        <div class="fancy-form">
                            <div>
                                <label class="helper-note">Full Name</label>
                                <asp:TextBox ID="txtFullName" runat="server" CssClass="fancy-input" placeholder="Enter your name"></asp:TextBox>
                            </div>
                            <div>
                                <label class="helper-note">Email</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="fancy-input" TextMode="Email" placeholder="Enter your email"></asp:TextBox>
                            </div>
                            <div>
                                <label class="helper-note">Phone Number</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="fancy-input" placeholder="e.g. 98XXXXXXXX"></asp:TextBox>
                            </div>
                            <div>
                                <label class="helper-note">Subject</label>
                                <asp:DropDownList ID="ddlSubject" runat="server" CssClass="fancy-select">
                                    <asp:ListItem Value="">Select topic</asp:ListItem>
                                    <asp:ListItem>General Inquiry</asp:ListItem>
                                    <asp:ListItem>Order Support</asp:ListItem>
                                    <asp:ListItem>Vendor Partnership</asp:ListItem>
                                    <asp:ListItem>Product Feedback</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                            <div class="full">
                                <label class="helper-note">Message</label>
                                <asp:TextBox ID="txtMessage" runat="server" CssClass="fancy-textarea" TextMode="MultiLine" placeholder="Write your message..."></asp:TextBox>
                            </div>
                            <div class="full">
                                <asp:Button ID="btnSubmitContact" runat="server" Text="Submit Message" CssClass="submit-btn" OnClick="btnSubmitContact_Click" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
