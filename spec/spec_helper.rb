# This part turns off the default RSpec database cleansing strategy.
config.use_transactional_fixtures = false

config.before(:suite) do
  # This says that before the entire test suite runs, clear the test database out completely.
  # This gets rid of any garbage left over from interrupted or poorly-written tests - a common source of surprising test behavior.
  DatabaseCleaner.clean_with(:truncation)

  # This part sets the default database cleaning strategy to be transactions.
  # Transactions are very fast, and for all the tests where they do work - that is, any test where the entire test runs in the RSpec process - they are preferable.
  DatabaseCleaner.strategy = :transaction
end

# These lines hook up database_cleaner around the beginning and end of each test,
# telling it to execute whatever cleanup strategy we selected beforehand.
config.before(:each) do
  DatabaseCleaner.start
end

config.after(:each) do
  DatabaseCleaner.clean
end








$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'sqlite3'
require 'acts_as_votable'

Dir["./spec/shared_example/**/*.rb"].sort.each {|f| require f}
Dir["./spec/support/**/*.rb"].sort.each {|f| require f}

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

ActiveRecord::Schema.define(:version => 1) do
  create_table :votes do |t|
    t.references :votable, :polymorphic => true
    t.references :voter, :polymorphic => true

    t.boolean :vote_flag
    t.string :vote_scope
    t.integer :vote_weight

    t.timestamps
  end

  add_index :votes, [:votable_id, :votable_type]
  add_index :votes, [:voter_id, :voter_type]
  add_index :votes, [:voter_id, :voter_type, :vote_scope]
  add_index :votes, [:votable_id, :votable_type, :vote_scope]

  create_table :voters do |t|
    t.string :name
  end

  create_table :not_voters do |t|
    t.string :name
  end

  create_table :votables do |t|
    t.string :name
  end

  create_table :votable_voters do |t|
    t.string :name
  end

  create_table :sti_votables do |t|
    t.string :name
    t.string :type
  end

  create_table :sti_not_votables do |t|
    t.string :name
    t.string :type
  end

  create_table :not_votables do |t|
    t.string :name
  end

  create_table :votable_caches do |t|
    t.string :name
    t.integer :cached_votes_total
    t.integer :cached_votes_score
    t.integer :cached_votes_up
    t.integer :cached_votes_down
    t.integer :cached_weighted_total
    t.integer :cached_weighted_score
    t.float :cached_weighted_average

    t.integer :cached_scoped_test_votes_total
    t.integer :cached_scoped_test_votes_score
    t.integer :cached_scoped_test_votes_up
    t.integer :cached_scoped_test_votes_down
    t.integer :cached_scoped_weighted_total
    t.integer :cached_scoped_weighted_score
    t.float :cached_scoped_weighted_average
  end

end


class Voter < ActiveRecord::Base
  acts_as_voter
end

class NotVoter < ActiveRecord::Base

end

class Votable < ActiveRecord::Base
  acts_as_votable
  validates_presence_of :name
end

class VotableVoter < ActiveRecord::Base
  acts_as_votable
  acts_as_voter
end

class StiVotable < ActiveRecord::Base
  acts_as_votable
end

class ChildOfStiVotable < StiVotable
end

class StiNotVotable < ActiveRecord::Base
  validates_presence_of :name
end

class VotableChildOfStiNotVotable < StiNotVotable
  acts_as_votable
end

class NotVotable < ActiveRecord::Base
end

class VotableCache < ActiveRecord::Base
  acts_as_votable
  validates_presence_of :name
end

class ABoringClass
  def self.hw
    'hello world'
  end
end


def clean_database
  models = [ActsAsVotable::Vote, Voter, NotVoter, Votable, NotVotable, VotableCache]
  models.each do |model|
    ActiveRecord::Base.connection.execute "DELETE FROM #{model.table_name}"
  end
end
