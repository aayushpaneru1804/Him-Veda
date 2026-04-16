<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Admin/Admin.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="HimVeda.Admin.Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Dashboard Analytics
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/jsvectormap/dist/css/jsvectormap.min.css" />
    <script src="https://cdn.jsdelivr.net/npm/jsvectormap"></script>
    <script src="https://cdn.jsdelivr.net/npm/jsvectormap/dist/maps/world.js"></script>

    <style>
        .page-header {
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-between;
            align-items: flex-end;
        }

        .page-title {
            margin: 0;
            font-size: 1.8rem;
            color: #181c32;
        }

        .page-subtitle {
            color: var(--admin-muted);
            margin-top: 0.5rem;
            font-size: 0.95rem;
            font-weight: 500;
        }

        /* Stats Grid */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 1.5rem;
            display: flex;
            align-items: center;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.02);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .stat-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 25px rgba(0,0,0,0.08);
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
        }

        .stat-card.blue::before { background: #3699ff; }
        .stat-card.orange::before { background: #ffa800; }
        .stat-card.green::before { background: #1bc5bd; }
        .stat-card.purple::before { background: #8950fc; }

        .stat-icon {
            width: 65px;
            height: 65px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.8rem;
            margin-right: 1.5rem;
        }

        .stat-card.blue .stat-icon { background: rgba(54, 153, 255, 0.1); color: #3699ff; }
        .stat-card.orange .stat-icon { background: rgba(255, 168, 0, 0.1); color: #ffa800; }
        .stat-card.green .stat-icon { background: rgba(27, 197, 189, 0.1); color: #1bc5bd; }
        .stat-card.purple .stat-icon { background: rgba(137, 80, 252, 0.1); color: #8950fc; }

        .stat-details {
            display: flex;
            flex-direction: column;
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: #181c32;
            line-height: 1.2;
            font-family: 'Outfit', sans-serif;
        }

        .stat-label {
            color: var(--admin-muted);
            font-weight: 600;
            font-size: 0.9rem;
            margin-top: 4px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        
        /* Charts Section */
        .chart-row {
            display: grid;
            gap: 1.5rem;
            margin-bottom: 1.5rem;
            grid-template-columns: repeat(2, 1fr);
        }
        
        .chart-row.three-cols {
            grid-template-columns: 1fr 1fr 1.5fr;
        }
        
        .chart-card {
            background: #ffffff;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.03);
            border: 1px solid rgba(0,0,0,0.02);
            display: flex;
            flex-direction: column;
        }

        .chart-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .chart-title {
            font-size: 1.15rem;
            font-weight: 600;
            color: #181c32;
            margin: 0;
        }
        
        .chart-badge {
            background: rgba(27, 197, 189, 0.1);
            color: #1bc5bd;
            padding: 4px 10px;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 600;
        }
        .chart-badge.info {
            background: rgba(54, 153, 255, 0.1);
            color: #3699ff;
        }
        
        .chart-container {
            position: relative;
            flex: 1;
            min-height: 250px;
        }

        #mapContainer {
            width: 100%;
            height: 100%;
            min-height: 250px;
            border-radius: 10px;
            overflow: hidden;
            background: transparent;
        }
        
        @media (max-width: 1200px) {
            .chart-row, .chart-row.three-cols { grid-template-columns: 1fr; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="page-header">
        <div>
            <h1 class="page-title">Dashboard Overview</h1>
            <div class="page-subtitle">Real-time metrics and system health for HimVeda Marketplace</div>
        </div>
        <div class="header-actions">
            <button type="button" class="btn" style="background: #ffffff; border: 1px solid #e4e6ef; padding: 10px 15px; border-radius: 8px; font-weight: 600; color: #3f4254; cursor: pointer; transition: all 0.3s; box-shadow: 0 2px 4px rgba(0,0,0,0.02);">
                <i class="fa-solid fa-download" style="margin-right: 8px; color: #3699ff;"></i> Export Report
            </button>
        </div>
    </div>

    <div class="stats-grid">
        <div class="stat-card blue">
            <div class="stat-icon"><i class="fa-solid fa-users"></i></div>
            <div class="stat-details">
                <div class="stat-value"><asp:Literal ID="litCustomers" runat="server">0</asp:Literal></div>
                <div class="stat-label">Total Customers</div>
            </div>
        </div>
        
        <div class="stat-card orange">
            <div class="stat-icon"><i class="fa-solid fa-store"></i></div>
            <div class="stat-details">
                <div class="stat-value"><asp:Literal ID="litVendors" runat="server">0</asp:Literal></div>
                <div class="stat-label">Active Vendors</div>
            </div>
        </div>
        
        <div class="stat-card green">
            <div class="stat-icon"><i class="fa-solid fa-boxes-stacked"></i></div>
            <div class="stat-details">
                <div class="stat-value"><asp:Literal ID="litProducts" runat="server">0</asp:Literal></div>
                <div class="stat-label">Live Products</div>
            </div>
        </div>
        
        <div class="stat-card purple">
            <div class="stat-icon"><i class="fa-solid fa-cart-shopping"></i></div>
            <div class="stat-details">
                <div class="stat-value"><asp:Literal ID="litOrders" runat="server">0</asp:Literal></div>
                <div class="stat-label">Total Orders</div>
            </div>
        </div>
    </div>
    
    <!-- Top Charts Layer -->
    <div class="chart-row">
        <div class="chart-card">
            <div class="chart-header">
                <h3 class="chart-title"><i class="fa-solid fa-arrow-trend-up" style="color: #1bc5bd; margin-right: 8px;"></i> Revenue Dynamics</h3>
                <span class="chart-badge">+15% This Month</span>
            </div>
            <div class="chart-container">
                <canvas id="revenueChart"></canvas>
            </div>
        </div>
        
        <div class="chart-card">
            <div class="chart-header">
                <h3 class="chart-title"><i class="fa-solid fa-user-plus" style="color: #3699ff; margin-right: 8px;"></i> User Registration Growth</h3>
                <span class="chart-badge info">Active Spikes</span>
            </div>
            <div class="chart-container">
                <canvas id="userGrowthChart"></canvas>
            </div>
        </div>
    </div>

    <!-- Secondary Charts Layer (Categories, Bar, Map) -->
    <div class="chart-row three-cols">
        <!-- Doughnut Chart: Categories -->
        <div class="chart-card">
            <div class="chart-header">
                <h3 class="chart-title">Market Share by Category</h3>
            </div>
            <div class="chart-container">
                <canvas id="categoryChart"></canvas>
            </div>
        </div>

        <!-- Bar Graph: Products per Vendor/Category -->
        <div class="chart-card">
            <div class="chart-header">
                <h3 class="chart-title">Products Inventory</h3>
            </div>
            <div class="chart-container">
                <canvas id="productBarChart"></canvas>
            </div>
        </div>

        <!-- Geographic Map -->
        <div class="chart-card">
            <div class="chart-header">
                <h3 class="chart-title"><i class="fa-solid fa-map-location-dot" style="color: #ffa800; margin-right: 8px;"></i> Global Delivery Reach</h3>
            </div>
            <div class="chart-container">
                <div id="mapContainer"></div>
            </div>
        </div>
    </div>

    <!-- Chart.js and Map Initialization -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            /* ----------------------------------
               1. REVENUE LINE CHART
            -----------------------------------*/
            const ctxRev = document.getElementById('revenueChart').getContext('2d');
            let gradientBlue = ctxRev.createLinearGradient(0, 0, 0, 400);
            gradientBlue.addColorStop(0, 'rgba(27, 197, 189, 0.4)');
            gradientBlue.addColorStop(1, 'rgba(27, 197, 189, 0.0)');
            
            new Chart(ctxRev, {
                type: 'line',
                data: {
                    labels: <%= RevenueLabels %>,
                    datasets: [{
                        label: 'Gross Sales (NPR)',
                        data: <%= RevenueData %>,
                        borderColor: '#1bc5bd',
                        backgroundColor: gradientBlue,
                        borderWidth: 3,
                        pointBackgroundColor: '#ffffff',
                        pointBorderColor: '#1bc5bd',
                        pointBorderWidth: 3,
                        pointRadius: 4,
                        fill: true,
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.03)' } },
                        x: { grid: { display: false } }
                    }
                }
            });

            /* ----------------------------------
               2. USER GROWTH LINE CHART
            -----------------------------------*/
            const ctxUser = document.getElementById('userGrowthChart').getContext('2d');
            let gradientPurp = ctxUser.createLinearGradient(0, 0, 0, 400);
            gradientPurp.addColorStop(0, 'rgba(54, 153, 255, 0.3)');
            gradientPurp.addColorStop(1, 'rgba(54, 153, 255, 0.0)');

            new Chart(ctxUser, {
                type: 'line',
                data: {
                    labels: <%= UserGrowthLabels %>,
                    datasets: [{
                        label: 'New Users',
                        data: <%= UserGrowthData %>,
                        borderColor: '#3699ff',
                        backgroundColor: gradientPurp,
                        borderWidth: 3,
                        pointBackgroundColor: '#3699ff',
                        pointRadius: 2,
                        fill: true,
                        tension: 0.5
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.03)' } },
                        x: { grid: { display: false } }
                    }
                }
            });

            /* ----------------------------------
               3. CATEGORY DOUGHNUT CHART
            -----------------------------------*/
            const ctxCat = document.getElementById('categoryChart').getContext('2d');
            new Chart(ctxCat, {
                type: 'doughnut',
                data: {
                    labels: <%= CategoryLabels %>,
                    datasets: [{
                        data: <%= CategoryData %>,
                        backgroundColor: ['#3699ff', '#1bc5bd', '#ffa800', '#f64e60'],
                        borderWidth: 0,
                        hoverOffset: 5
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false, cutout: '75%',
                    plugins: { legend: { position: 'bottom', labels: { usePointStyle: true, padding: 15 } } }
                }
            });

            /* ----------------------------------
               4. PRODUCT INVENTORY BAR CHART
            -----------------------------------*/
            const ctxBar = document.getElementById('productBarChart').getContext('2d');
            new Chart(ctxBar, {
                type: 'bar',
                data: {
                    labels: <%= ProductLabels %>,
                    datasets: [{
                        label: 'Active Products',
                        data: <%= ProductData %>,
                        backgroundColor: '#8950fc',
                        borderRadius: 6
                    }]
                },
                options: {
                    responsive: true, maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    scales: {
                        y: { beginAtZero: true, grid: { color: 'rgba(0,0,0,0.03)' } },
                        x: { grid: { display: false } }
                    }
                }
            });

            /* ----------------------------------
               5. JS VECTOR MAP
            -----------------------------------*/
            new jsVectorMap({
                selector: '#mapContainer',
                map: 'world',
                zoomButtons: false,
                regionStyle: {
                    initial: {
                        fill: '#e4e6ef',
                        stroke: 'none',
                        strokeWidth: 0,
                        fillOpacity: 1
                    },
                    hover: {
                        fill: '#ffa800',
                        fillOpacity: 0.8
                    }
                },
                markers: [
                    { name: 'Nepal (HQ)', coords: [28.3949, 84.1240] },
                    { name: 'India', coords: [20.5937, 78.9629] },
                    { name: 'USA', coords: [37.0902, -95.7129] }
                ],
                markerStyle: {
                    initial: {
                        fill: '#f64e60',
                        stroke: '#fff',
                        strokeWidth: 2,
                        r: 6
                    },
                    hover: {
                        fill: '#3699ff',
                        stroke: '#fff',
                        strokeWidth: 2,
                    }
                }
            });
        });
    </script>
</asp:Content>
