require_relative('../db/sql_runner.rb')

class Eatery

  attr_reader :id
  attr_accessor :name, :location

  def initialize( options )
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @location = options['location']
  end

  def save()
    sql = "INSERT INTO eateries
    (
      name,
      location
    )
    VALUES
    (
      $1, $2
    )
    RETURNING id"
    values = [@name, @location]
    results = SqlRunner.run(sql, values)
    @id = results.first()['id'].to_i
  end

  def delete()
    sql = "DELETE FROM eateries
    WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def self.all()
    sql = "SELECT * FROM eateries;"
    values = []
    results = SqlRunner.run( sql, values )
    return results.map { |eatery| Eatery.new( eatery ) }
  end

  def self.find(id)
    sql = "SELECT * FROM eateries
    WHERE id = $1"
    values = [id]
    results = SqlRunner.run(sql, values)
    return Eatery.new(results.first)
  end


end
