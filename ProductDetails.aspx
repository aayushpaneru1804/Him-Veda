<%@ Page Title="Product Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ProductDetails.aspx.cs" Inherits="HimVeda.ProductDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    <asp:Literal ID="litTitle" runat="server">Product Details</asp:Literal>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .star-rating { direction: rtl; display: inline-flex; font-size: 2rem; }
        .star-rating input { display: none; }
        .star-rating label { color: #cbd5e1; cursor: pointer; padding: 0 0.1rem; transition: color 0.2s; }
        .star-rating input:checked ~ label,
        .star-rating label:hover,
        .star-rating label:hover ~ label { color: #f59e0b; }

        .details-container {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 4rem;
            margin-top: 3rem;
            background: white;
            padding: 3rem;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
        }
        .main-img-container {
            width: 100%;
            height: 500px;
            border-radius: var(--border-radius);
            overflow: hidden;
            background: #f8fafc;
        }
        .main-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .info-container { display: flex; flex-direction: column; }
        .product-name { font-size: 2.5rem; color: var(--primary-dark); margin-bottom: 1rem; }
        .product-price { font-size: 2rem; color: var(--primary-color); font-weight: 700; margin-bottom: 1rem; }
        .product-stock { font-size: 1rem; color: var(--success); margin-bottom: 2rem; font-weight: 600; }
        .product-desc { color: var(--text-muted); line-height: 1.8; margin-bottom: 2rem; }
        .qty-controls { display: flex; align-items: center; gap: 1rem; margin-bottom: 2rem; }
        .qty-input { width: 80px; text-align: center; font-weight: bold; }
        
        @media (max-width: 768px) {
            .details-container { grid-template-columns: 1fr; gap: 2rem; padding: 1.5rem; }
            .main-img-container { height: 350px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container">
        
        <asp:Label ID="lblError" runat="server" CssClass="text-center mt-4" style="display:block; color: var(--danger); font-size: 1.2rem;" Visible="false"></asp:Label>
        
        <asp:Panel ID="pnlDetails" runat="server" CssClass="details-container">
            <div class="main-img-container">
                <asp:Image ID="imgMain" runat="server" CssClass="main-img" />
            </div>
            
            <div class="info-container">
                <h1 class="product-name"><asp:Literal ID="litProductName" runat="server"></asp:Literal></h1>
                <div class="product-price"><asp:Literal ID="litPrice" runat="server"></asp:Literal></div>
                <div class="product-stock"><i class="fa-solid fa-check-circle"></i> <asp:Literal ID="litStock" runat="server"></asp:Literal> in stock</div>
                
                <h3 style="margin-bottom: 0.5rem; font-size: 1.2rem;">About this product</h3>
                <div class="product-desc"><asp:Literal ID="litDesc" runat="server"></asp:Literal></div>

                <asp:Panel ID="pnlVariations" runat="server" Visible="false" style="margin-bottom: 1.2rem;">
                    <label style="font-weight: 600; display: block; margin-bottom: 0.5rem;">Choose variation</label>
                    <asp:DropDownList ID="ddlVariations" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlVariations_SelectedIndexChanged"></asp:DropDownList>
                </asp:Panel>
                
                <div class="qty-controls">
                    <label style="font-weight: 600;">Quantity:</label>
                    <asp:TextBox ID="txtQty" runat="server" CssClass="form-control qty-input" TextMode="Number" Text="1" min="1"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="rfvQty" runat="server" ControlToValidate="txtQty" ErrorMessage="Required." CssClass="validator-error" Display="Dynamic"></asp:RequiredFieldValidator>
                    <asp:RangeValidator ID="rvQty" runat="server" ControlToValidate="txtQty" ErrorMessage="Must be 1 or more." MinimumValue="1" MaximumValue="999" Type="Integer" CssClass="validator-error" Display="Dynamic"></asp:RangeValidator>
                </div>
                
                <div class="flex gap-2">
                    <asp:Button ID="btnAddToCart" runat="server" Text="Add to Cart" CssClass="btn btn-primary" style="flex: 2; padding: 1rem; font-size: 1.1rem;" OnClick="btnAddToCart_Click" />
                    <asp:LinkButton ID="btnWishlist" runat="server" CssClass="btn btn-outline" style="flex: 1; padding: 1rem; display: flex; justify-content: center; align-items: center;" OnClick="btnWishlist_Click"><i class="fa-regular fa-heart mr-2"></i> Wishlist</asp:LinkButton>
                </div>
            </div>
        </asp:Panel>
        
        <div style="margin-top: 4rem; border-top: 1px solid #e2e8f0; padding-top: 2rem; margin-bottom: 4rem;">
            <h2 style="margin-bottom: 2rem;">Frequently Bought Together</h2>
            <div class="product-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 1.5rem;">
                <asp:Repeater ID="rptRelated" runat="server">
                    <ItemTemplate>
                        <a href='<%# "ProductDetails.aspx?id=" + Eval("ProductID") %>' class="card" style="text-decoration:none; color:inherit; display:block;">
                            <img src='<%# ResolveUrl(Eval("MainImage").ToString() == "" ? "~/Images/placeholder.png" : Eval("MainImage").ToString()) %>' alt='<%# Eval("ProductName") %>' style="width: 100%; height: 200px; object-fit:cover;" />
                            <div style="padding: 1rem;">
                                <h4 style="font-size: 1.1rem; color: var(--primary-dark); font-weight: 600;"><%# Eval("ProductName") %></h4>
                                <div style="font-size: 1.25rem; font-weight: 700; color: var(--primary-color); margin-top: 0.5rem;"><%# Eval("Price", "{0:C}") %></div>
                            </div>
                        </a>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
            
            <div style="margin-top: 4rem; padding-top: 2rem; border-top: 1px solid #e2e8f0;">
                <h2 style="margin-bottom: 2rem;"><i class="fa-solid fa-star" style="color: #fbbf24;"></i> Customer Reviews</h2>
                
                <asp:Label ID="lblNoReviews" runat="server" Text="No reviews yet. Be the first to review this product after purchase!" Visible="false" style="color: var(--text-muted); font-style: italic;"></asp:Label>
                
                <div style="display: flex; flex-direction: column; gap: 1.5rem;">
                    <asp:Repeater ID="rptReviews" runat="server">
                        <ItemTemplate>
                            <div style="background: #f8fafc; padding: 1.5rem; border-radius: 12px; border: 1px solid #e2e8f0;">
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                                    <h4 style="margin: 0; font-size: 1.1rem; color: var(--primary-dark);"><i class="fa-regular fa-circle-user" style="color: var(--text-muted); margin-right: 5px;"></i> <%# Eval("FullName") %></h4>
                                    <span style="color: #94a3b8; font-size: 0.9rem;"><%# Eval("FeedbackDate", "{0:MMM dd, yyyy}") %></span>
                                </div>
                                <div style="color: #fbbf24; margin-bottom: 1rem; font-size: 1.1rem;">
                                    <%# GenerateStars(Eval("Rating")) %>
                                </div>
                                <p style="margin: 0; color: #475569; line-height: 1.6;"><%# Eval("Comment") %></p>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <!-- Review Submission Form -->
                <asp:Panel ID="pnlLeaveReview" runat="server" Visible="false" style="margin-top: 3rem; background: #f8fafc; padding: 2rem; border-radius: 12px; border: 1px solid #e2e8f0;">
                    <h3 style="margin-bottom: 1.5rem;"><i class="fa-solid fa-pen-nib text-primary mr-2"></i> Write a Review</h3>
                    
                    <asp:Label ID="lblReviewMsg" runat="server" CssClass="mb-3 block" Visible="false"></asp:Label>
                    
                    <div class="form-group mb-4">
                        <label class="form-label block mb-2">Overall Rating</label>
                        <div class="star-rating">
                            <asp:RadioButton ID="star5" runat="server" GroupName="rating" /> <label for="<%= star5.ClientID %>"><i class="fa-solid fa-star"></i></label>
                            <asp:RadioButton ID="star4" runat="server" GroupName="rating" /> <label for="<%= star4.ClientID %>"><i class="fa-solid fa-star"></i></label>
                            <asp:RadioButton ID="star3" runat="server" GroupName="rating" /> <label for="<%= star3.ClientID %>"><i class="fa-solid fa-star"></i></label>
                            <asp:RadioButton ID="star2" runat="server" GroupName="rating" /> <label for="<%= star2.ClientID %>"><i class="fa-solid fa-star"></i></label>
                            <asp:RadioButton ID="star1" runat="server" GroupName="rating" /> <label for="<%= star1.ClientID %>"><i class="fa-solid fa-star"></i></label>
                        </div>
                    </div>

                    <div class="form-group mb-4">
                        <label class="form-label block mb-2">Add a written review (optional)</label>
                        <asp:TextBox ID="txtReviewComment" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="What did you like or dislike?"></asp:TextBox>
                    </div>

                    <asp:Button ID="btnSubmitReview" runat="server" Text="Submit Review" CssClass="btn btn-primary" OnClick="btnSubmitReview_Click" />
                </asp:Panel>
                
                <asp:Panel ID="pnlLoginToReview" runat="server" style="margin-top: 3rem; text-align: center; background: #f8fafc; padding: 2rem; border-radius: 12px; border: 1px dashed #cbd5e1;">
                    <p style="color: var(--text-muted); margin-bottom: 1rem;">You must be logged in to write a review.</p>
                    <a href="Login.aspx" class="btn btn-outline">Login to Review</a>
                </asp:Panel>

            </div>
        </div>
        
    </div>
</asp:Content>
