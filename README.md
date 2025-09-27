# Cursor Website

A modern, production-ready Cursor Website with a secure admin panel, optimized for VPS deployment. This application allows users to browse and copy AI prompts for image generation, while providing administrators with a secure interface to manage content.

## 🎨 Features

### Public Gallery
- **Modern Design**: Clean, minimalistic, and futuristic UI matching the provided design
- **Category Filtering**: Browse prompts by categories (All, Men, Women, Couple, Kids)
- **One-Click Copy**: Instantly copy any AI prompt to clipboard
- **Real-time Updates**: Gallery updates automatically when new prompts are added
- **Responsive Design**: Perfect viewing experience on desktop, tablet, and mobile
- **Live Statistics**: Display total prompts and category counts

### Admin Panel
- **Secure Authentication**: Username/password login with JWT tokens
- **CRUD Operations**: Add, edit, and delete prompts
- **Image Management**: Support for HTTPS image URLs from trusted domains
- **Category Management**: Organize prompts by categories
- **Real-time Updates**: Changes reflect immediately in the public gallery
- **Responsive Interface**: Admin panel works on all devices

### Technical Features
- **VPS Ready**: Optimized for Ubuntu server deployment
- **SSL/HTTPS**: Automatic SSL certificate setup with Let's Encrypt
- **PM2 Process Management**: Auto-restart and monitoring
- **Nginx Reverse Proxy**: High-performance web server configuration
- **SQLite Database**: Lightweight, file-based database
- **Security**: Input validation, XSS protection, secure authentication
- **Logging**: Comprehensive logging and monitoring

## 🚀 Quick VPS Deployment

### Prerequisites
- Ubuntu 20.04+ VPS
- Root or sudo access
- Domain name pointing to your VPS IP
- Email address for SSL certificate

### One-Command Deployment

1. **Upload your project files** to your VPS:
   ```bash
   # Upload the entire project folder to your VPS
   scp -r ai-prompt-gallery/ root@your-vps-ip:/var/www/
   ```

2. **Run the deployment script**:
   ```bash
   ssh root@your-vps-ip
   cd /var/www/ai-prompt-gallery
   chmod +x deploy.sh
   ./deploy.sh
   ```

3. **Update configuration** (edit the script before running):
   ```bash
   # Edit deploy.sh and update these variables:
   DOMAIN="your-domain.com"  # Your actual domain
   EMAIL="your-email@example.com"  # Your email for SSL
   ```

### Manual Deployment Steps

If you prefer manual setup:

#### 1. System Setup
```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Node.js 18.x
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install PM2
sudo npm install -g pm2

# Install Nginx
sudo apt install -y nginx

# Install Certbot for SSL
sudo apt install -y certbot python3-certbot-nginx
```

#### 2. Application Setup
```bash
# Create application directory
sudo mkdir -p /var/www/ai-prompt-gallery
sudo chown -R www-data:www-data /var/www/ai-prompt-gallery

# Copy your project files to /var/www/ai-prompt-gallery/
# Install dependencies
cd /var/www/ai-prompt-gallery
npm install

# Setup database
npm run db:setup
npm run db:seed

# Build application
npm run build
```

#### 3. Nginx Configuration
```bash
# Copy Nginx configuration
sudo cp nginx.conf /etc/nginx/sites-available/ai-prompt-gallery
sudo ln -s /etc/nginx/sites-available/ai-prompt-gallery /etc/nginx/sites-enabled/
sudo rm -f /etc/nginx/sites-enabled/default

# Test and restart Nginx
sudo nginx -t
sudo systemctl restart nginx
```

#### 4. SSL Certificate
```bash
# Get SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com
```

#### 5. PM2 Setup
```bash
# Start application with PM2
pm2 start ecosystem.config.js
pm2 save
pm2 startup

# Setup log rotation
pm2 install pm2-logrotate
```

## 🔧 Configuration

### Environment Variables
Create a `.env.local` file for production:
```env
NODE_ENV=production
JWT_SECRET=your-super-secret-jwt-key-change-in-production
PORT=3000
```

### Database
The application uses SQLite for simplicity. The database file is created at `database.sqlite` in the project root.

### Default Admin Credentials
- **Username**: `admin`
- **Password**: `admin123`

⚠️ **IMPORTANT**: Change these credentials immediately after deployment!

## 📁 Project Structure

```
ai-prompt-gallery/
├── app/                    # Next.js app directory
│   ├── api/               # API routes
│   │   ├── login/         # Authentication endpoint
│   │   ├── prompts/       # Prompts CRUD endpoints
│   │   └── stats/         # Statistics endpoint
│   ├── admin/             # Admin panel pages
│   ├── globals.css        # Global styles
│   ├── layout.tsx         # Root layout
│   └── page.tsx           # Main gallery page
├── components/            # React components
│   ├── PromptCard.tsx     # Individual prompt card
│   ├── CategoryFilter.tsx # Category filtering
│   └── StatsDisplay.tsx   # Statistics display
├── lib/                   # Utility libraries
│   ├── database.js        # Database operations
│   └── auth.js           # Authentication utilities
├── scripts/               # Database setup scripts
│   ├── setup-db.js       # Database initialization
│   └── seed-db.js        # Sample data seeding
├── ecosystem.config.js    # PM2 configuration
├── nginx.conf            # Nginx configuration
├── deploy.sh             # Deployment script
└── README.md             # This file
```

## 🔒 Security Features

- **JWT Authentication**: Secure token-based authentication
- **Password Hashing**: bcrypt for secure password storage
- **Input Validation**: Comprehensive validation for all inputs
- **XSS Protection**: Sanitized inputs and secure headers
- **HTTPS Only**: SSL/TLS encryption for all communications
- **Admin Route Protection**: Secure admin panel access
- **Image URL Validation**: Only trusted domains allowed

## 🛠️ Development

### Local Development
```bash
# Install dependencies
npm install

# Setup database
npm run db:setup
npm run db:seed

# Start development server
npm run dev
```

### Available Scripts
- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npm run db:setup` - Initialize database
- `npm run db:seed` - Add sample data

## 📊 Monitoring & Maintenance

### PM2 Commands
```bash
pm2 status                    # Check application status
pm2 logs ai-prompt-gallery    # View application logs
pm2 restart ai-prompt-gallery # Restart application
pm2 reload ai-prompt-gallery  # Reload without downtime
pm2 monit                     # Monitor resources
```

### Nginx Commands
```bash
sudo systemctl status nginx   # Check Nginx status
sudo nginx -t                 # Test configuration
sudo systemctl reload nginx   # Reload configuration
```

### SSL Certificate Renewal
```bash
# Test renewal
sudo certbot renew --dry-run

# Manual renewal
sudo certbot renew
```

### Log Files
- Application logs: `/var/log/pm2/`
- Nginx logs: `/var/log/nginx/`
- System logs: `/var/log/syslog`

## 🔄 Updates & Backups

### Application Updates
```bash
# Pull latest changes
cd /var/www/ai-prompt-gallery
git pull origin main

# Install new dependencies
npm install

# Build and restart
npm run build
pm2 restart ai-prompt-gallery
```

### Database Backup
```bash
# Backup database
cp /var/www/ai-prompt-gallery/database.sqlite /backup/database-$(date +%Y%m%d).sqlite

# Restore database
cp /backup/database-20240101.sqlite /var/www/ai-prompt-gallery/database.sqlite
pm2 restart ai-prompt-gallery
```

## 🐛 Troubleshooting

### Common Issues

1. **Application won't start**
   ```bash
   pm2 logs ai-prompt-gallery
   # Check for errors in logs
   ```

2. **Nginx 502 Bad Gateway**
   ```bash
   # Check if Node.js app is running
   pm2 status
   # Check Nginx configuration
   sudo nginx -t
   ```

3. **SSL Certificate Issues**
   ```bash
   # Check certificate status
   sudo certbot certificates
   # Renew if needed
   sudo certbot renew
   ```

4. **Database Issues**
   ```bash
   # Recreate database
   npm run db:setup
   npm run db:seed
   ```

### Performance Optimization

1. **Enable Gzip Compression** (already configured in nginx.conf)
2. **Set up CDN** for static assets
3. **Monitor Resource Usage** with PM2
4. **Regular Database Cleanup** of old logs

## 📝 API Documentation

### Authentication
- `POST /api/login` - Admin login
- Headers: `Authorization: Bearer <token>` for protected routes

### Prompts
- `GET /api/prompts` - Get all prompts (public)
- `GET /api/prompts?category=Men` - Filter by category
- `POST /api/prompts` - Create prompt (admin only)
- `PUT /api/prompts/:id` - Update prompt (admin only)
- `DELETE /api/prompts/:id` - Delete prompt (admin only)

### Statistics
- `GET /api/stats` - Get prompt statistics (public)

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 🆘 Support

For support and questions:
1. Check the troubleshooting section
2. Review the logs for error messages
3. Ensure all dependencies are properly installed
4. Verify your VPS configuration

---

**Built with ❤️ for the AI community**

*This application is production-ready and optimized for VPS deployment with security, performance, and scalability in mind.*
