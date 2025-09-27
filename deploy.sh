#!/bin/bash

# Cursor Website - VPS Deployment Script
# Run this script on your Ubuntu VPS to deploy the application

set -e

echo "🚀 Starting Cursor Website deployment..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
APP_NAME="cursor-website"
APP_DIR="/var/www/$APP_NAME"
DOMAIN="your-domain.com"  # Change this to your domain
EMAIL="your-email@example.com"  # Change this to your email

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    print_error "Please run this script as root (use sudo)"
    exit 1
fi

print_status "Updating system packages..."
apt update && apt upgrade -y

print_status "Installing Node.js 18.x..."
curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
apt-get install -y nodejs

print_status "Installing PM2 globally..."
npm install -g pm2

print_status "Installing Nginx..."
apt install -y nginx

print_status "Installing Certbot for SSL..."
apt install -y certbot python3-certbot-nginx

print_status "Creating application directory..."
mkdir -p $APP_DIR
chown -R www-data:www-data $APP_DIR

print_status "Setting up firewall..."
ufw allow 'Nginx Full'
ufw allow ssh
ufw --force enable

print_status "Configuring Nginx..."
cp nginx.conf /etc/nginx/sites-available/$APP_NAME
sed -i "s/your-domain.com/$DOMAIN/g" /etc/nginx/sites-available/$APP_NAME
ln -sf /etc/nginx/sites-available/$APP_NAME /etc/nginx/sites-enabled/
rm -f /etc/nginx/sites-enabled/default

print_status "Testing Nginx configuration..."
nginx -t

print_status "Starting Nginx..."
systemctl start nginx
systemctl enable nginx

print_status "Setting up SSL certificate..."
certbot --nginx -d $DOMAIN -d www.$DOMAIN --email $EMAIL --agree-tos --non-interactive

print_status "Setting up PM2 log directory..."
mkdir -p /var/log/pm2
chown -R www-data:www-data /var/log/pm2

print_status "Creating PM2 startup script..."
pm2 startup systemd -u www-data --hp /var/www
pm2 save

print_status "Setting up log rotation..."
cat > /etc/logrotate.d/pm2 << EOF
/var/log/pm2/*.log {
    daily
    missingok
    rotate 52
    compress
    delaycompress
    notifempty
    create 644 www-data www-data
    postrotate
        pm2 reloadLogs
    endscript
}
EOF

print_status "Creating systemd service for PM2..."
cat > /etc/systemd/system/pm2-www-data.service << EOF
[Unit]
Description=PM2 process manager
Documentation=https://pm2.keymetrics.io/
After=network.target

[Service]
Type=notify
User=www-data
LimitNOFILE=infinity
LimitNPROC=infinity
LimitCORE=infinity
Environment=PATH=/usr/bin:/usr/local/bin
Environment=PM2_HOME=/var/www/.pm2
ExecStart=/usr/bin/pm2-runtime start /var/www/$APP_NAME/ecosystem.config.js
ExecReload=/usr/bin/pm2 reload all
ExecStop=/usr/bin/pm2 kill

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable pm2-www-data

print_status "Setting up database..."
cd $APP_DIR
npm run db:setup
npm run db:seed

print_status "Building application..."
npm run build

print_status "Starting application with PM2..."
pm2 start ecosystem.config.js
pm2 save

print_status "Restarting services..."
systemctl restart nginx
systemctl restart pm2-www-data

print_status "Setting up monitoring..."
pm2 install pm2-logrotate

print_status "Deployment completed successfully! 🎉"
echo ""
echo "Your AI Prompt Gallery is now running at: https://$DOMAIN"
echo "Admin panel: https://$DOMAIN/admin"
echo "Default admin credentials:"
echo "  Username: admin"
echo "  Password: admin123"
echo ""
print_warning "IMPORTANT: Change the default admin password immediately!"
echo ""
echo "Useful commands:"
echo "  pm2 status                    - Check application status"
echo "  pm2 logs ai-prompt-gallery    - View application logs"
echo "  pm2 restart ai-prompt-gallery - Restart application"
echo "  systemctl status nginx        - Check Nginx status"
echo "  certbot renew --dry-run       - Test SSL renewal"
echo ""
print_status "Deployment script completed!"
