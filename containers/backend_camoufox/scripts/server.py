import os

from camoufox.server import launch_server

launch_server(
    headless=True,
    host=os.environ["CAMOUFOX_HOST"],
    port=int(os.environ["CAMOUFOX_PORT"]),
    ws_path=os.environ["CAMOUFOX_WS_PATH"],
)
