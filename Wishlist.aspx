<%@ Page Title="My Wishlist" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Wishlist.aspx.cs" Inherits="HimVeda.Wishlist" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    My Wishlist
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .wishlist-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
            margin-top: 1.5rem;
        }
        
        .wishlist-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-sm);
            overflow: hidden;
            transition: transform var(--transition-speed);
            border: 1px solid #e2e8f0;
        }
        
        .wishlist-card:hover { 
            transform: translateY(-5px); 
            box-shadow: var(--shadow-lg); 
        }
        
        .wishlist-img { width: 100%; height: 200px; object-fit: cover; }
        .wishlist-info { padding: 1.5rem; }
        .wishlist-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-main); }
        .wishlist-price { color: var(--primary-color); font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem; }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container my-4">
        <h2><i class="fa-solid fa-heart mr-2" style="color:var(--danger)"></i> My Wishlist</h2>
        <p class="text-muted">Items you've saved for later.</p>

        <asp:Label ID="lblError" runat="server" CssClass="badge badge-warning" Visible="false" style="display:block; margin: 1rem 0; width: fit-content; font-size:1rem;"></asp:Label>
        <asp:Label ID="lblSuccess" runat="server" CssClass="badge badge-success" Visible="false" style="display:block; margin: 1rem 0; width: fit-content; font-size:1rem;"></asp:Label>

        <div class="wishlist-grid">
            <asp:Repeater ID="rptWishlist" runat="server" OnItemCommand="rptWishlist_ItemCommand">
                <ItemTemplate>
                    <div class="wishlist-card flex-col justify-between">
                        <div>
                            <img src='<%# ResolveUrl(Eval("MainImage").ToString() == "" ? "~/Images/placeholder.png" : Eval("MainImage").ToString()) %>' alt='<%# Eval("ProductName") %>' class="wishlist-img" />
                            <div class="wishlist-info">
                                <h3 class="wishlist-title"><%# Eval("ProductName") %></h3>
                                <div class="wishlist-price"><%# Eval("Price", "{0:C}") %></div>
                            </div>
                        </div>
                        <div class="flex gap-1" style="padding: 0 1.5rem 1.5rem 1.5rem;">
                            <asp:LinkButton ID="btnRemove" runat="server" CommandName="Remove" CommandArgument='<%# Eval("WishlistItemID") %>' CssClass="btn btn-outline" style="flex:1; border-color:var(--danger); color:var(--danger);">Remove</asp:LinkButton>
                            <asp:LinkButton ID="btnCart" runat="server" CommandName="AddCart" CommandArgument='<%# Eval("ProductID") + "|" + Eval("WishlistItemID") %>' CssClass="btn btn-primary" style="flex:1;">To Cart <i class="fa-solid fa-arrow-right ml-1"></i></asp:LinkButton>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <asp:Panel ID="pnlEmpty" runat="server" Visible="false" CssClass="text-center" style="padding: 4rem 1rem;">
            <i class="fa-regular fa-heart" style="font-size:4rem; color: #cbd5e1; margin-bottom: 1rem;"></i>
            <h3>Your wishlist is empty</h3>
            <p class="text-muted" style="margin-bottom: 2rem;">Looks like you haven't added any authentic products to your wishlist yet.</p>
            <a href="Products.aspx" class="btn btn-primary">Discover Products</a>
        </asp:Panel>
    </div>
</asp:Content>
