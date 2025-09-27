module.exports = {
  apps: [
    {
      name: 'cursor-website',
      script: 'npm',
      args: 'start',
      cwd: '/var/www/cursor-website',
      instances: 1,
      autorestart: true,
      watch: false,
      max_memory_restart: '1G',
      env: {
        NODE_ENV: 'production',
        PORT: 3000,
        JWT_SECRET: 'your-super-secret-jwt-key-change-in-production'
      },
      error_file: '/var/log/pm2/cursor-website-error.log',
      out_file: '/var/log/pm2/cursor-website-out.log',
      log_file: '/var/log/pm2/cursor-website.log',
      time: true
    }
  ]
};
