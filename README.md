# Dependencies
- QBCore Framework (https://github.com/qbcore-framework/)
- Oxmysql (https://github.com/overextended/oxmysql)

# Installation

# Initial Configuration
**To add reputation point values to an action:**
1. Open `server/config.lua`
2. Scroll down to `Config.Actions`
3. Ensure there is a job sub-table created.
   1. You can accomplish this by writing `[job_name_here] = {}`
4. Inside that sub-table, you can list actions and accompanying point values.
   1. For example: `['burgershot'] = { ['sold_burger'] = 2 }`

**Default Action:**
This action is added in case the specified action is not found.

# Client-Side Functionality
In regards to the client, you are going to simply make event calls to the server-side of the script. I decided against adding direct client-side functionality in an attempt to avoid player abuse via an executor (though it is still more than possible). There was also no overwhelming reason to duplicate the code on the client-side as everything can be properly handled from the server.

# Server-Side Functionality
## Adding Reputation Tables
Instead of forcing people that use your script to alter the config for this script, you can add reputation types through an export. Please ensure that your script starts **after** pe-reputation does to ensure the export is actually added.
```lua
exports['pe-reputation']:AddReputationType({
   ['grades'] = {},
   ['actions'] = {},
   ['isJob'] = true
})
```
## Adding Reputation
You can easily add reputation to a player by using the following:
```lua
exports['pe-reputation']:AddReputation({})
```
Now, this export comes with a bunch of different options, which are fed to the function in a table.
```lua
exports['pe-reputation']:AddReputation({
    -- REQUIRED | Typically, you will run this export from an event. You need to pass through the source.
    ['source'] = src,
    -- REQUIRED | This is the reputation identifier.
    ['identifier'] = '',
    -- REQUIRED | What action are we rewarding? This directly ties to a point value.
    ['action'] = '',
})
```