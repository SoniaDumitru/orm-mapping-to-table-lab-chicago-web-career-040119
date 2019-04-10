class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]
  #we initialize Student instances with name, grade, and id

  attr_accessor :name, :grade
  #student responds to a getter for id
  #and does not provide a setter for :id
  attr_reader :id

  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
  end

  #create the student table in the database
   def self.create_table
    sql = <<-SQL
          CREATE TABLE IF NOT EXISTS students (
            id INTEGER PRIMARY KEY,
            name TEXT,
            grade INTEGER
          );
          SQL
    DB[:conn].execute(sql)
   end

   #drops the student table
  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  #describs a given student to the students table
  def save
    sql = <<-SQL
          INSERT INTO students (name, grade)
          VALUES (?, ?)
        SQL
      DB[:conn].execute(sql, self.name, self.grade)
    #select last inserted row and assign it to be the value of the @id attribute of the given instance
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
  end

  def self.create(name:, grade:)
    student = Student.new(name, grade)
    student.save
    student
  end

end
