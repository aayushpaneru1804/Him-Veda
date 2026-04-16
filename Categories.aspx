<%@ Page Title="Categories" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Categories.aspx.cs" Inherits="HimVeda.PublicCategories" %>
<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Shop Categories
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .category-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
            margin-bottom: 3rem;
        }
        
        .category-card {
            background: var(--surface-color);
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            padding: 2.5rem 1.5rem;
            text-align: center;
            transition: all var(--transition-speed);
            position: relative;
            overflow: hidden;
            border: 1px solid rgba(0,0,0,0.04);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }

        .category-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0; height: 5px;
            background: var(--primary-light);
            transform: scaleX(0);
            transform-origin: left;
            transition: transform var(--transition-speed);
        }

        .category-card:hover {
            transform: translateY(-5px);
            box-shadow: var(--shadow-lg);
        }

        .category-card:hover::before {
            transform: scaleX(1);
        }

        .cat-thumb-wrap {
            width: 140px;
            height: 140px;
            margin-bottom: 1rem;
            border-radius: 16px;
            overflow: hidden;
            flex-shrink: 0;
            background: var(--secondary-color);
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: var(--shadow-sm);
        }
        .cat-photo {
            width: 100%;
            height: 100%;
            object-fit: cover;
            display: block;
        }
        .cat-icon {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
            background: var(--secondary-color);
            width: 80px;
            height: 80px;
            line-height: 80px;
            border-radius: 50%;
            display: inline-block;
        }

        .category-card h3 {
            font-size: 1.4rem;
            margin-bottom: 0.5rem;
        }

        .category-card p {
            color: var(--text-muted);
            font-size: 0.95rem;
            margin-bottom: 1.5rem;
        }
    </style>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container my-4">
        <div class="text-center" style="margin-bottom: 3rem;">
            <h1>Browse Categories</h1>
            <p class="text-muted">Explore authentic Himalayan collections curated just for you.</p>
        </div>

        <div class="category-grid">
            <asp:Repeater ID="rptCategories" runat="server">
                <ItemTemplate>
                    <a href='<%# "Products.aspx?cat=" + Eval("CategoryID") %>' class="category-card" style="text-decoration:none; color:inherit;">
                        <asp:PlaceHolder runat="server" Visible='<%# ResolveCategoryImage(Eval("CategoryImage")) != null %>'>
                            <div class="cat-thumb-wrap">
                                <img src='<%# ResolveCategoryImage(Eval("CategoryImage")) %>' alt="" class="cat-photo" />
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder runat="server" Visible='<%# ResolveCategoryImage(Eval("CategoryImage")) == null %>'>
                            <div class="cat-icon"><i class="fa-solid fa-leaf"></i></div>
                        </asp:PlaceHolder>
                        <h3><%# Eval("CategoryName") %></h3>
                        <p><%# Eval("Description") %></p>
                        <span class="btn btn-outline" style="border-radius: 20px;">Browse Selection</span>
                    </a>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <asp:Label ID="lblEmpty" runat="server" Text="No categories available at the moment." CssClass="text-muted text-center" Visible="false" style="display:block; padding: 3rem;"></asp:Label>
    </div>
</asp:Content>
