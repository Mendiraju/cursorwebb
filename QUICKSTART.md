# 🚀 Cursor Website - Quick Start Guide

## Local Development (5 minutes)

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Setup database:**
   ```bash
   npm run db:setup
   npm run db:seed
   ```

3. **Start development server:**
   ```bash
   npm run dev
   ```

4. **Open your browser:**
   - Gallery: http://localhost:3000
   - Admin: http://localhost:3000/admin
   - Login: admin / admin123

## VPS Deployment (10 minutes)

1. **Upload to your VPS:**
   ```bash
   scp -r ai-prompt-gallery/ root@your-vps-ip:/var/www/
   ```

2. **Edit configuration:**
   ```bash
   # Edit deploy.sh
   DOMAIN="your-domain.com"
   EMAIL="your-email@example.com"
   ```

3. **Run deployment:**
   ```bash
   ssh root@your-vps-ip
   cd /var/www/ai-prompt-gallery
   chmod +x deploy.sh
   ./deploy.sh
   ```

4. **Access your site:**
   - Gallery: https://your-domain.com
   - Admin: https://your-domain.com/admin

## Features Checklist ✅

- [x] Modern, responsive design matching the provided screenshot
- [x] Category filtering (All, Men, Women, Couple, Kids)
- [x] One-click copy to clipboard
- [x] Real-time updates
- [x] Secure admin panel with authentication
- [x] CRUD operations for prompts
- [x] Input validation and security
- [x] VPS-ready deployment
- [x] SSL/HTTPS support
- [x] PM2 process management
- [x] Nginx reverse proxy
- [x] Database backup and maintenance
- [x] Comprehensive documentation

## Default Credentials

- **Username:** admin
- **Password:** admin123

⚠️ **Change these immediately after deployment!**

## Useful Commands

```bash
# Development
npm run dev              # Start dev server
npm run build           # Build for production
npm run start           # Start production server

# Database
npm run db:setup        # Initialize database
npm run db:seed         # Add sample data
npm run maintenance     # Run maintenance tasks

# Testing
npm test                # Test setup
```

## Support

- Check `README.md` for detailed documentation
- Review logs: `pm2 logs ai-prompt-gallery`
- Health check: `curl https://your-domain.com/api/health`

---

**Ready to deploy! 🎉**
