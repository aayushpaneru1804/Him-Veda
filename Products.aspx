<%@ Page Title="Products" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Products.aspx.cs" Inherits="HimVeda.PublicProducts" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Products Catalog
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .catalog-container { display: flex; gap: 2rem; margin-top: 2rem; }
        .filter-sidebar { width: 250px; flex-shrink: 0; }
        .product-grid { flex: 1; display: grid; grid-template-columns: repeat(auto-fill, minmax(220px, 1fr)); gap: 1.5rem; }
        .product-card { background: white; border-radius: var(--border-radius); box-shadow: var(--shadow-sm); transition: transform 0.2s; overflow: hidden; }
        .product-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .product-img { width: 100%; height: 200px; object-fit: cover; }
        .product-info { padding: 1rem; }
        .product-title { font-size: 1.1rem; font-weight: 600; color: var(--text-main); margin-bottom: 0.5rem; }
        .product-price { color: var(--primary-color); font-weight: 700; font-size: 1.2rem; }
        .filter-title { font-weight: 700; color: var(--primary-dark); margin-bottom: 1rem; padding-bottom: 0.5rem; border-bottom: 2px solid var(--secondary-color); font-size: 1.3rem; }
        .category-list { list-style: none; padding: 0; }
        .category-list li { margin-bottom: 0.5rem; }
        .category-list a { 
            color: var(--text-muted); 
            font-weight: 600; 
            transition: all 0.2s; 
            display: block; 
            padding: 0.5rem 0.8rem; 
            border-radius: 6px; 
            text-decoration: none;
        }
        .category-list a:hover { 
            color: var(--primary-dark); 
            background: rgba(0,0,0,0.03); 
            font-weight: 700; 
            transform: translateX(4px);
        }
        .category-list a.active { 
            color: white; 
            background: var(--primary-color); 
            font-weight: 700; 
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container catalog-container">
        
        <!-- Sidebar Filters -->
        <aside class="filter-sidebar">
            <div class="card" style="padding: 1.5rem;">
                <h3 class="filter-title">Categories</h3>
                <asp:Repeater ID="rptCategories" runat="server">
                    <HeaderTemplate><ul class="category-list"></HeaderTemplate>
                    <ItemTemplate>
                        <li>
                            <a href='Products.aspx?cat=<%# Eval("CategoryID") %>' class='<%# Request.QueryString["cat"] == Eval("CategoryID").ToString() ? "active" : "" %>'>
                                <%# Eval("CategoryName") %>
                            </a>
                        </li>
                    </ItemTemplate>
                    <FooterTemplate></ul></FooterTemplate>
                </asp:Repeater>
                
                <div style="margin-top: 2rem;">
                    <a href="Products.aspx" class="btn btn-outline" style="width: 100%;">Clear Filters</a>
                </div>
            </div>
        </aside>

        <!-- Product Grid -->
        <main style="flex: 1;">
            <asp:Label ID="lblBanner" runat="server" CssClass="filter-title" style="display:block; font-size: 1.5rem; margin-bottom: 1.5rem;"></asp:Label>

            <div class="product-grid">
                <asp:Repeater ID="rptProducts" runat="server" OnItemCommand="rptProducts_ItemCommand">
                    <ItemTemplate>
                        <div class="product-card">
                            <a href='ProductDetails.aspx?id=<%# Eval("ProductID") %>'>
                                <img src='<%# ResolveUrl(Eval("MainImage").ToString() == "" ? "~/Images/placeholder.png" : Eval("MainImage").ToString()) %>' alt='<%# Eval("ProductName") %>' class="product-img" />
                            </a>
                            <div class="product-info">
                                <a href='ProductDetails.aspx?id=<%# Eval("ProductID") %>'>
                                    <h3 class="product-title"><%# Eval("ProductName") %></h3>
                                </a>
                                <div class="product-price"><%# Eval("Price", "{0:C}") %></div>
                                <div class="flex gap-1" style="margin-top: 1rem;">
                                    <asp:LinkButton ID="btnAddCart" runat="server" CommandName="AddCart" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-primary" style="flex: 1; padding: 0.5rem;">Add to Cart</asp:LinkButton>
                                    <asp:LinkButton ID="btnAddWishlist" runat="server" CommandName="AddWishlist" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-outline" style="padding: 0.5rem;"><i class="fa-regular fa-heart"></i></asp:LinkButton>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
                <asp:Label ID="lblEmpty" runat="server" Visible="false" Text="No products found in this category." CssClass="text-muted" style="grid-column: 1/-1; text-align: center; padding: 3rem;"></asp:Label>
            </div>
        </main>
    </div>
</asp:Content>
