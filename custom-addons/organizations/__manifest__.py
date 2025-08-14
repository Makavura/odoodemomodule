{
    "name": "Organizations Demo",
    "version": "1.0",
    "category": "Website",
    "summary": "Demonstrates fetching and displaying API data in Odoo.",
    "description": """
        A simple module to showcase:
        - Fetching external API data.
        - Displaying data using QWeb templates.
        - Integrating Tailwind CSS for styling.
    """,
    "license": "LGPL-3",
    "author": "Makavura Mughanga",
    "depends": ["base", "website"],
    "data": ["views/organization_template.xml"],
    "assets": {
        "web.assets_frontend": [
            "organizations/static/src/css/tailwind.css",
            "organizations/static/src/js/organization.js",
        ]
    },
    "installable": True,
    "application": True,
    "auto_install": False,
}
