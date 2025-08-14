from odoo import http
import logging
import requests

_logger = logging.getLogger(__name__)


class OrganizationDirectory(http.Controller):
    @http.route("/organization-directory", auth="public", website=True)
    def users(self, **kwargs):
        try:
            response = requests.get(
                "https://jsonplaceholder.typicode.com/users", timeout=5
            )
            users = response.json() if response.status_code == 200 else []
        except Exception as e:
            _logger.error(f"Error fetching users: {e}")
            users = []

        return http.request.render(
            "organizations.organization_template", {"users": users}
        )
    
