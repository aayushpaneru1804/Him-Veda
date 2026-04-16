<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="HimVeda.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Home
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .hero {
            background: linear-gradient(135deg, rgba(27,67,50,0.6), rgba(82,183,136,0.4)), url('Images/himalayan_banner.png') center/cover;
            color: white;
            padding: 6rem 2rem;
            border-radius: var(--border-radius);
            margin-bottom: 3rem;
            text-align: center;
            box-shadow: var(--shadow-lg);
        }
        .hero h1 {
            color: white;
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        .hero p {
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto 2rem;
            color: #d1fae5;
        }
        
        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
            margin-top: 1.5rem;
        }
        
        .product-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-md);
            overflow: hidden;
            transition: transform var(--transition-speed);
        }
        .product-card:hover { transform: translateY(-5px); box-shadow: var(--shadow-lg); }
        .product-img { width: 100%; height: 200px; object-fit: cover; }
        .product-info { padding: 1.5rem; }
        .product-title { font-size: 1.2rem; font-weight: 600; margin-bottom: 0.5rem; color: var(--text-main); }
        .product-price { color: var(--primary-color); font-size: 1.25rem; font-weight: 700; margin-bottom: 1rem; }
        
        .section-header { text-align: center; margin-bottom: 2rem; }
        .section-header h2 { font-size: 2rem; }
        .section-header p { color: var(--text-muted); }
        .cta-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(220px, 1fr));
            gap: 1.25rem;
            margin-top: 3rem;
        }
        .cta-grid-card {
            background: #fff;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            box-shadow: var(--shadow-md);
            padding: 2rem 1.5rem;
            text-align: center;
        }
        @media (max-width: 980px) {
            .cta-grid { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    
    <div class="container">
        <!-- Hero Section -->
        <div class="hero">
            <h1>Discover Authentic Himalayan Vita</h1>
            <p>100% natural, organic and medicinal products directly sourced from the pure altitudes of the Himalayas to your doorstep.</p>
            <a href="Products.aspx" class="btn btn-primary" style="font-size: 1.1rem; padding: 0.8rem 2rem;">Shop Collection <i class="fa-solid fa-arrow-right ml-2"></i></a>
        </div>

        <!-- Features / Why Choose Us -->
        <div class="features-section" style="margin-top: 3rem; margin-bottom: 3rem; position: relative; z-index: 10; padding: 0 1rem; display: flex; flex-wrap: wrap; justify-content: center; gap: 2rem;">
            <div class="feature-box" style="background: white; padding: 2rem; border-radius: 16px; box-shadow: var(--shadow-lg); width: 100%; max-width: 320px; text-align: center; flex: 1 1 300px;">
                <div style="width: 60px; height: 60px; background: #D8F3DC; color: #2D6A4F; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 1rem;">
                    <i class="fa-solid fa-leaf"></i>
                </div>
                <h3 style="font-size: 1.2rem; margin-bottom: 0.5rem; color: #1e293b;">100% Organic</h3>
                <p style="color: #64748b; font-size: 0.95rem;">Purely wildcrafted and organic ingredients harvested at high altitudes.</p>
            </div>
            
            <div class="feature-box" style="background: white; padding: 2rem; border-radius: 16px; box-shadow: var(--shadow-lg); width: 100%; max-width: 320px; text-align: center; flex: 1 1 300px;">
                <div style="width: 60px; height: 60px; background: #fee2e2; color: #ef4444; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 1rem;">
                    <i class="fa-solid fa-heart-pulse"></i>
                </div>
                <h3 style="font-size: 1.2rem; margin-bottom: 0.5rem; color: #1e293b;">Medicinal Grade</h3>
                <p style="color: #64748b; font-size: 0.95rem;">Ayurvedic formulas trusted for centuries to boost immunity and wellness.</p>
            </div>
            
            <div class="feature-box" style="background: white; padding: 2rem; border-radius: 16px; box-shadow: var(--shadow-lg); width: 100%; max-width: 320px; text-align: center; flex: 1 1 300px;">
                <div style="width: 60px; height: 60px; background: #e0e7ff; color: #4f46e5; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin: 0 auto 1rem;">
                    <i class="fa-solid fa-truck-fast"></i>
                </div>
                <h3 style="font-size: 1.2rem; margin-bottom: 0.5rem; color: #1e293b;">Directly to You</h3>
                <p style="color: #64748b; font-size: 0.95rem;">Fast and secure delivery from the Himalayan vendors straight to your door.</p>
            </div>
        </div>

        <!-- Special Project Offers Section -->
        <div class="section-header" style="margin-top: 4rem;">
            <h2><i class="fa-solid fa-tag" style="color: #f64e60;"></i> Special Project Offers</h2>
            <p>Exclusive deals on authentic Himalayan supplements and items</p>
        </div>

        <div class="product-grid">
            <asp:Repeater ID="rptOffers" runat="server" OnItemCommand="rptFeatured_ItemCommand">
                <ItemTemplate>
                    <div class="product-card" style="border: 1px solid #f64e60; position: relative;">
                        <span style="position: absolute; top: 10px; right: 10px; background: #f64e60; color: white; padding: 4px 10px; border-radius: 4px; font-size: 0.8rem; font-weight: bold; z-index: 10;">Special Offer</span>
                        <img src='<%# ResolveUrl(Eval("MainImage").ToString() == "" ? "~/Images/placeholder.png" : Eval("MainImage").ToString()) %>' alt='<%# Eval("ProductName") %>' class="product-img" style="height: 180px;" />
                        <div class="product-info">
                            <h3 class="product-title" style="font-size: 1.1rem;"><%# Eval("ProductName") %></h3>
                            <div class="product-price"><%# Eval("Price", "{0:C}") %></div>
                            <div class="flex gap-1">
                                <asp:LinkButton ID="btnView" runat="server" CommandName="View" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-outline" style="flex: 1; padding: 0.5rem;">Details</asp:LinkButton>
                                <asp:LinkButton ID="btnAddCart" runat="server" CommandName="AddCart" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-primary" style="padding: 0.5rem 1rem;"><i class="fa-solid fa-cart-shopping"></i></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <div style="text-align: center; margin-top: 2rem;">
            <a href="Products.aspx" class="btn btn-outline">View All Offers</a>
        </div>

        <!-- Featured Products -->
        <div class="section-header" style="margin-top: 5rem;">
            <h2>Featured Wellness</h2>
            <p>Our top-rated natural elixirs from the majestic peaks</p>
        </div>

        <div class="product-grid">
            <asp:Repeater ID="rptFeatured" runat="server" OnItemCommand="rptFeatured_ItemCommand">
                <ItemTemplate>
                    <div class="product-card">
                        <img src='<%# ResolveUrl(Eval("MainImage").ToString() == "" ? "~/Images/placeholder.png" : Eval("MainImage").ToString()) %>' alt='<%# Eval("ProductName") %>' class="product-img" />
                        <div class="product-info">
                            <h3 class="product-title"><%# Eval("ProductName") %></h3>
                            <div class="product-price"><%# Eval("Price", "{0:C}") %></div>
                            
                            <div class="flex gap-1">
                                <asp:LinkButton ID="btnView" runat="server" CommandName="View" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-outline" style="flex: 1;">View Details</asp:LinkButton>
                                <asp:LinkButton ID="btnAddCart" runat="server" CommandName="AddCart" CommandArgument='<%# Eval("ProductID") %>' CssClass="btn btn-primary" style="padding: 0.6rem 1rem;"><i class="fa-solid fa-cart-shopping"></i></asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
        
        <!-- Testimonial Section -->
        <div class="section-header" style="margin-top: 5rem;">
            <h2>What Our Customers Say</h2>
            <p>Real stories from our wellness community</p>
        </div>
        
        <div class="product-grid">
            <asp:Repeater ID="rptTestimonials" runat="server">
                <ItemTemplate>
                    <div class="card" style="padding: 2rem; text-align: center;">
                        <img src='<%# ResolveUrl(GetProfileImage(Eval("ProfileImage"))) %>' alt='<%# Eval("FullName") %>' style="width: 85px; height: 85px; object-fit: cover; border-radius: 50%; margin: 0 auto 1.2rem; border: 3px solid #e2e8f0;" />
                        <div style="font-size: 1.5rem; color: #fbbf24; margin-bottom: 1rem;"><%# GetStars(Convert.ToInt32(Eval("Rating"))) %></div>
                        <p style="font-style: italic; color: #475569; margin-bottom: 1rem;">"<%# Eval("Comment") %>"</p>
                        <h4 style="color: var(--primary-dark);">- <%# Eval("FullName") %></h4>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Combined CTA Grid -->
        <div class="cta-grid" style="margin-top: 5rem;">
            <div class="cta-grid-card">
                <div style="font-size: 2.2rem; color: #166534; margin-bottom: 0.8rem;"><i class="fa-solid fa-store"></i></div>
                <h3 style="font-size: 1.5rem; margin-bottom: 0.7rem;">Are you a local vendor?</h3>
                <p style="color: #475569; margin-bottom: 1rem;">Join HimVeda and expand your reach across the globe.</p>
                <a href="Register.aspx" class="btn btn-primary">Become a Seller <i class="fa-solid fa-store ml-2"></i></a>
            </div>

            <div class="cta-grid-card">
                <div style="font-size: 2.2rem; color: #0284c7; margin-bottom: 0.8rem;"><i class="fa-solid fa-map-location-dot"></i></div>
                <h3 style="font-size: 1.5rem; margin-bottom: 0.7rem;">Contact Our Office</h3>
                <p style="color: #475569; margin-bottom: 1rem;">HimVeda | Sanu Complex | Available 24/7</p>
                <a href="Contact.aspx" class="btn btn-primary">Contact Us <i class="fa-solid fa-arrow-right ml-2"></i></a>
            </div>

            <div class="cta-grid-card">
                <div style="font-size: 2.2rem; color: #f59e0b; margin-bottom: 0.8rem;"><i class="fa-regular fa-comment-dots"></i></div>
                <h3 style="font-size: 1.5rem; margin-bottom: 0.7rem;">Share Feedback</h3>
                <p style="color: #475569; margin-bottom: 1rem;">Your feedback helps us improve and serve you better.</p>
                <a href="Feedback.aspx" class="btn btn-primary">Give Feedback <i class="fa-solid fa-arrow-right ml-2"></i></a>
            </div>
        </div>
    </div>
</asp:Content>
