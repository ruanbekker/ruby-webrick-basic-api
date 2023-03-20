require 'webrick'
require 'json'
require 'sqlite3'

class MyApi < WEBrick::HTTPServlet::AbstractServlet
  def initialize(server, db)
    super(server)
    @db = db
    create_table_if_not_exists
  end

  def create_table_if_not_exists
    # create the "items" table if it doesn't exist
    @db.execute <<-SQL
      CREATE TABLE IF NOT EXISTS items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT NOT NULL
      );
    SQL
  end

  def do_GET(request, response)
    # Handle GET request
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = get_all_items.to_json
  end

  def do_POST(request, response)
    # Handle POST request
    request_body = JSON.parse(request.body)
    item_name = request_body['name']
    item_description = request_body['description']
    @db.execute('INSERT INTO items (name, description) VALUES (?, ?)', item_name, item_description)
    response.status = 201
    response['Content-Type'] = 'application/json'
    response.body = get_all_items.to_json
  end

  def do_PUT(request, response)
    # Handle PUT request
    request_body = JSON.parse(request.body)
    item_id = request_body['id']
    item_name = request_body['name']
    item_description = request_body['description']
    @db.execute('UPDATE items SET name = ?, description = ? WHERE id = ?', item_name, item_description, item_id)
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = get_all_items.to_json
  end

  def do_DELETE(request, response)
    # Handle DELETE request
    request_body = JSON.parse(request.body)
    item_id = request_body['id']
    @db.execute('DELETE FROM items WHERE id = ?', item_id)
    response.status = 200
    response['Content-Type'] = 'application/json'
    response.body = get_all_items.to_json
  end

  def get_all_items
    # fetch all items from the "items" table
    result = @db.execute('SELECT * FROM items')
    items = []
    result.each do |row|
      items << { id: row[0], name: row[1], description: row[2] }
    end
    { items: items }
  end
end

# connect to the SQLite database
db = SQLite3::Database.new('sqlite.db')

server = WEBrick::HTTPServer.new(Port: 8080)
server.mount '/api', MyApi, db
trap('INT') { server.shutdown }
server.start
