<%@ Page Title="Register" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="HimVeda.Register" %>

<asp:Content ID="Content1" ContentPlaceHolderID="TitleContent" runat="server">
    Register
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="HeadContent" runat="server">
    <style>
        .register-tabs {
            display: flex;
            margin-bottom: 2rem;
            border-bottom: 2px solid #e2e8f0;
        }
        .register-tab {
            flex: 1;
            text-align: center;
            padding: 1rem;
            cursor: pointer;
            font-weight: 600;
            color: var(--text-muted);
            transition: all var(--transition-speed);
        }
        .register-tab.active {
            color: var(--primary-color);
            border-bottom: 2px solid var(--primary-color);
            margin-bottom: -2px;
        }
    </style>
    <script>
        function toggleForm(type) {
            if (type === 'customer') {
                document.getElementById('customer-tab').classList.add('active');
                document.getElementById('vendor-tab').classList.remove('active');
                document.getElementById('customer-form').style.display = 'block';
                document.getElementById('vendor-form').style.display = 'none';
                document.getElementById('<%= hiddenRegType.ClientID %>').value = 'customer';
                
                if (typeof ValidatorEnable === 'function') {
                    ValidatorEnable(document.getElementById('<%= rfvCustName.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvCustEmail.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= revCustEmail.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= revCustPhone.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvCustPass.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvCustDOB.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvCustSecQ.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvCustSecA.ClientID %>'), true);
                    
                    ValidatorEnable(document.getElementById('<%= rfvVendName.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvVendBiz.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvVendEmail.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= revVendEmail.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= revVendPhone.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvVendPass.ClientID %>'), false);
                }
            } else {
                document.getElementById('vendor-tab').classList.add('active');
                document.getElementById('customer-tab').classList.remove('active');
                document.getElementById('vendor-form').style.display = 'block';
                document.getElementById('customer-form').style.display = 'none';
                document.getElementById('<%= hiddenRegType.ClientID %>').value = 'vendor';
                
                if (typeof ValidatorEnable === 'function') {
                    ValidatorEnable(document.getElementById('<%= rfvCustName.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvCustEmail.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= revCustEmail.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= revCustPhone.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvCustPass.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvCustDOB.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvCustSecQ.ClientID %>'), false);
                    ValidatorEnable(document.getElementById('<%= rfvCustSecA.ClientID %>'), false);
                    
                    ValidatorEnable(document.getElementById('<%= rfvVendName.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvVendBiz.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvVendEmail.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= revVendEmail.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= revVendPhone.ClientID %>'), true);
                    ValidatorEnable(document.getElementById('<%= rfvVendPass.ClientID %>'), true);
                }
            }
        }
        
        // Ensure accurate state on initial load
        window.onload = function() {
            toggleForm(document.getElementById('<%= hiddenRegType.ClientID %>').value || 'customer');
        };
    </script>
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="MainContent" runat="server">
    <div class="auth-container">
        <h2 class="text-center mb-4" style="margin-bottom: 2rem;">Create an Account</h2>
        
        <asp:Label ID="lblMessage" runat="server" CssClass="text-center mb-4" style="display:block; margin-bottom: 1rem;" BackColor="#fee2e2" ForeColor="#ef4444" Visible="false"></asp:Label>
        <asp:Label ID="lblSuccess" runat="server" CssClass="text-center mb-4" style="display:block; margin-bottom: 1rem;" BackColor="#d1fae5" ForeColor="#10b981" Visible="false"></asp:Label>

        <div class="register-tabs">
            <div id="customer-tab" class="register-tab active" onclick="toggleForm('customer')">Customer</div>
            <div id="vendor-tab" class="register-tab" onclick="toggleForm('vendor')">Vendor</div>
        </div>

        <asp:HiddenField ID="hiddenRegType" runat="server" Value="customer" />

        <!-- Customer Form -->
        <div id="customer-form">
            <div class="form-group">
                <label class="form-label">Full Name</label>
                <asp:TextBox ID="txtCustName" runat="server" CssClass="form-control" placeholder="John Doe"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCustName" runat="server" ControlToValidate="txtCustName" ErrorMessage="Name is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label class="form-label">Email Address</label>
                <asp:TextBox ID="txtCustEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="john@example.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCustEmail" runat="server" ControlToValidate="txtCustEmail" ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revCustEmail" runat="server" ControlToValidate="txtCustEmail" ErrorMessage="Only @gmail.com is accepted." CssClass="validator-error" Display="Dynamic" ValidationExpression="^[a-zA-Z0-9_.+-]+@gmail\.com$" ValidationGroup="RegisterGroup"></asp:RegularExpressionValidator>
            </div>
            <div class="form-group">
                <label class="form-label">Phone Number</label>
                <asp:TextBox ID="txtCustPhone" runat="server" CssClass="form-control" placeholder="9xxxxxxxx"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revCustPhone" runat="server" ControlToValidate="txtCustPhone" ErrorMessage="Must be 10 digits starting with 9." CssClass="validator-error" Display="Dynamic" ValidationExpression="^9\d{9}$" ValidationGroup="RegisterGroup"></asp:RegularExpressionValidator>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtCustPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCustPass" runat="server" ControlToValidate="txtCustPassword" ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label class="form-label">Profile Image (Optional)</label>
                <asp:FileUpload ID="fuCustProfileImage" runat="server" CssClass="form-control" accept="image/jpeg,image/png,image/webp" />
            </div>

            <div class="form-group">
                <label class="form-label">Date of Birth</label>
                <asp:TextBox ID="txtCustDOB" runat="server" CssClass="form-control" TextMode="Date"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCustDOB" runat="server" ControlToValidate="txtCustDOB" ErrorMessage="Date of Birth is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>

            <div class="form-group">
                <label class="form-label">Security Question</label>
                <asp:DropDownList ID="ddlCustSecQuestion" runat="server" CssClass="form-control">
                    <asp:ListItem Text="-- Select a security question --" Value=""></asp:ListItem>
                    <asp:ListItem Text="What is your favorite herb?" Value="What is your favorite herb?"></asp:ListItem>
                    <asp:ListItem Text="What is your birth city?" Value="What is your birth city?"></asp:ListItem>
                    <asp:ListItem Text="What is your pet name?" Value="What is your pet name?"></asp:ListItem>
                    <asp:ListItem Text="What is your favorite food?" Value="What is your favorite food?"></asp:ListItem>
                    <asp:ListItem Text="What is your school name?" Value="What is your school name?"></asp:ListItem>
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="rfvCustSecQ" runat="server" ControlToValidate="ddlCustSecQuestion" ErrorMessage="Security Question is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>
            
            <div class="form-group">
                <label class="form-label">Security Answer</label>
                <asp:TextBox ID="txtCustSecAnswer" runat="server" CssClass="form-control" placeholder="Secret answer"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvCustSecA" runat="server" ControlToValidate="txtCustSecAnswer" ErrorMessage="Security Answer is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>
        </div>

        <!-- Vendor Form -->
        <div id="vendor-form" style="display: none;">
            <div class="form-group">
                <label class="form-label">Manager / Owner Name</label>
                <asp:TextBox ID="txtVendName" runat="server" CssClass="form-control" placeholder="Jane Doe"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvVendName" runat="server" ControlToValidate="txtVendName" ErrorMessage="Owner Name is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label class="form-label">Business / Shop Name</label>
                <asp:TextBox ID="txtBusinessName" runat="server" CssClass="form-control" placeholder="Himalayan Traders"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvVendBiz" runat="server" ControlToValidate="txtBusinessName" ErrorMessage="Business Name is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>
            <div class="form-group">
                <label class="form-label">Business Email</label>
                <asp:TextBox ID="txtVendEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="shop@example.com"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvVendEmail" runat="server" ControlToValidate="txtVendEmail" ErrorMessage="Email is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
                <asp:RegularExpressionValidator ID="revVendEmail" runat="server" ControlToValidate="txtVendEmail" ErrorMessage="Only @gmail.com is accepted." CssClass="validator-error" Display="Dynamic" ValidationExpression="^[a-zA-Z0-9_.+-]+@gmail\.com$" ValidationGroup="RegisterGroup"></asp:RegularExpressionValidator>
            </div>
            <div class="form-group">
                <label class="form-label">Phone Number</label>
                <asp:TextBox ID="txtVendPhone" runat="server" CssClass="form-control" placeholder="9xxxxxxxx"></asp:TextBox>
                <asp:RegularExpressionValidator ID="revVendPhone" runat="server" ControlToValidate="txtVendPhone" ErrorMessage="Must be 10 digits starting with 9." CssClass="validator-error" Display="Dynamic" ValidationExpression="^9\d{9}$" ValidationGroup="RegisterGroup"></asp:RegularExpressionValidator>
            </div>
            <div class="form-group">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtVendPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="••••••••"></asp:TextBox>
                <asp:RequiredFieldValidator ID="rfvVendPass" runat="server" ControlToValidate="txtVendPassword" ErrorMessage="Password is required." CssClass="validator-error" Display="Dynamic" ValidationGroup="RegisterGroup"></asp:RequiredFieldValidator>
            </div>
        </div>

        <asp:Button ID="btnRegister" runat="server" Text="Register Now" CssClass="btn btn-primary" style="width: 100%; padding: 0.8rem;" ValidationGroup="RegisterGroup" OnClick="btnRegister_Click" />
        
        <p class="text-center mt-2" style="margin-top: 1.5rem;">
            Already have an account? <a href="Login.aspx" style="font-weight: 600;">Sign in here</a>
        </p>
    </div>
</asp:Content>
