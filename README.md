> UI:

<img width="1339" height="920" alt="image" src="https://github.com/user-attachments/assets/43703bdb-28e1-413d-a604-dfdf65315357" />


> Features implemented

Purpose: Display a list of users fetched from a public API in a styled, responsive layout in a self hosted Odoo instance using a custom module

Tech in Play:
    - Tailwind CSS (custom styling)
    - Odoo QWeb templating (for rendering the list)
    - Python controller (to fetch API data server-side)

> Folder structure

        odoodemomodule/
        ├── __init__.py
        ├── __manifest__.py
        ├── controllers/
        │   ├── __init__.py
        │   └── main.py
        ├── static/
        │   └── src/
        │       └── css/
        │           └── tailwind.css
                └── js/
                    └── organization.js
        ├── views/
        │   └── organization_template.xml
        └── models/
            ├── __init__.py
            └── organization.py

> Requirements:
- Postgres database
- Odoo instance

> Setup (Automated):
- Run `chmod +x run.bash`
- Run `./run.bash` to invoke the bash script that will pull a postgres db and odoo from docker registry if non-existent and will start the containers if existent. This is great for devX, allowing one to check changes on the fly.

> Setup (Manual):
 - To run Odoo from docker: `docker run -p 8069:8069 --name odoo --link db:db -t odoo:16` with no custom addons
 - Run Odoo with mounted addons path _(local image non-existent) _

    ```
    sudo docker run -p 8069:8069 \
        --name odoo \
        --link db:db \
        -t \
        -v /home/${whoami}/code/odoo/odoodemomodule:/mnt/custom-addons \
        odoo:16 \
        --addons-path=/mnt/custom-addons
    ```

- Run Odoo with mounted addons path using 

> PS: Things to remember

- This runs locally.
- The attached `run.bash` script runs with the `DB_USER` set to `odoo`, this creates a default user `odoo` and does not create the default user `postgres`. This will prevent odoo from running and will most likely raise the error: `ERROR ? odoo.modules.loading: Database db not initialized,`. To prevent this from happening, you can do one of two things, either: 
    - set user to `postgres` or not and the database will be created with this default, 
    remember to set password.
    - create a new `postgres` user with a password, grant privileges and ownership on the database e.g: 
        ```
        sudo docker exec -it db bash
        psql -U odoo -d db
        CREATE ROLE postgres WITH LOGIN PASSWORD 'odoo' SUPERUSER CREATEDB CREATEROLE;
        ALTER DATABASE db OWNER TO postgres;
        GRANT ALL PRIVILEGES ON DATABASE db TO postgres;
        \q
        ```
- The default postgres database name referenced by Odoo is `db`. 

> Post script invocation

- Navigate to http://localhost:8069/web/
- You will be redirected to http://localhost:8069/web/database/selector
- Afterwards you will be redirected to http://localhost:8069/web/login to login
- Once logged in, you should see a list of apps (default, provided by odoo)

> Aux.

If you forcefully exit the process since the docker(Odoo) is not running in detached mode,
there might be an issue of container name being already in use.
In that scenario, you can run `./safe-remove-container.sh odoo-dev`.
You might have to run the script twice; you can pass the custom container name you have used.

To be able to view debug mode and access developer settings, add `?debug=1` to `http://localhost:8069/web` i.e `http://localhost:8069/web`

In case you need to reset Odoo database for a fresh start:
`sudo docker exec -it db psql -U odoo -d postgres -c "DROP DATABASE db;"`
`sudo docker exec -it db psql -U odoo -d postgres -c "CREATE DATABASE db;"`

