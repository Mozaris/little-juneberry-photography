# Little Juneberry Photography - Project Configuration

## File Organization
```
HTML/
├── index.html              # Main homepage
├── about.html             # About page
├── contact.html           # Contact page
├── robots.txt             # SEO file
├── sitemap.xml           # SEO file
├── .htaccess             # Server configuration
├── HTML.code-workspace   # VS Code workspace settings
├── PERFORMANCE_IMPROVEMENTS.md # Performance documentation
├── pages/                # Secondary pages
│   ├── portfolio.html     # Portfolio page
│   ├── services.html      # Services page
│   ├── wedding.html       # Wedding service page
│   ├── engagement.html    # Engagement service page
│   ├── family.html        # Family service page
│   ├── special-occasion.html # Special occasion service page
│   └── 404.html          # Error page
├── scripts/              # PowerShell development scripts
│   ├── image-optimization/
│   │   ├── compress-images.ps1
│   │   ├── generate-webp.ps1
│   │   ├── optimize-images.ps1
│   │   ├── optimize-images-fixed.ps1
│   │   ├── quick-image-audit.ps1
│   │   └── simple-compress.ps1
│   ├── development/
│   │   ├── dev-helper.ps1
│   │   ├── performance-audit.ps1
│   │   ├── update-headers.ps1
│   │   └── update-page-paths.ps1
│   └── css-tools/
│       ├── add-shared-css.ps1
│       └── fix-css-order.ps1
├── assets/
│   ├── css/
│   │   ├── styles.css      # Main stylesheet
│   │   └── header-footer.css # Header/footer styles
│   ├── js/
│   │   ├── main.js         # Main JavaScript
│   │   └── includes.js     # Include system
│   ├── images/             # All image assets
│   │   ├── about/
│   │   ├── family/
│   │   ├── portfolio/
│   │   └── wedding/
│   └── icons/              # All favicon and icon files
│       ├── manifest.json
│       └── browserconfig.xml
├── includes/
│   ├── header.html         # Shared header template (root pages)
│   ├── header-pages.html   # Shared header template (pages subfolder)
│   └── footer.html         # Shared footer template
├── fonts/                  # Custom fonts
├── docs/                   # Documentation
│   ├── PROJECT_STRUCTURE.md
│   └── HEADER_STANDARDIZATION.md
└── (empty folders cleaned up)
```

## Development Guidelines

### CSS Organization
- All styles are now in `assets/css/main.css`
- Uses CSS custom properties for consistent theming
- Responsive design with mobile-first approach

### JavaScript Organization
- All scripts are in `assets/js/main.js`
- Uses modern JavaScript with event listeners
- Modular code organization

### Image Organization
- All images are in `assets/images/` with category subfolders
- Icons and favicons are in `assets/icons/`
- Use the `optimize-images.ps1` script to optimize images

### Best Practices
1. Always use relative paths for internal links
2. Keep HTML semantic and accessible
3. Use the shared header/footer includes where possible
4. Maintain consistent naming conventions
5. Test on multiple devices and screen sizes

## File Purposes
- `index.html` - Homepage with slideshow
- `portfolio.html` - Photo gallery with lightbox
- `about.html` - About the photographer
- `contact.html` - Contact form and information
- `services.html` - Overview of services
- Individual service pages for detailed information
- `robots.txt` & `sitemap.xml` - SEO optimization
- `.htaccess` - Server configuration and redirects
