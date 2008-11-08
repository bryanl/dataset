module Dataset
  class TestSuite
    def initialize(suite, test_class)
      @suite = suite
      @test_class = test_class
    end
    
    def run(result, &progress_block)
      @test_class.dataset_session.load_datasets_for(@test_class) if @test_class.dataset_session
      @suite.run(result, &progress_block)
    end
    
    def method_missing(method_symbol, *args)
      @suite.send(method_symbol, *args)
    end
  end
end

class Test::Unit::TestCase
  class << self
    def suite_with_dataset
      Dataset::TestSuite.new(suite_without_dataset, self)
    end
    alias_method_chain :suite, :dataset
    
    def dataset(dataset)
      @dataset_session ||= Dataset::Session.new(Dataset::Database::Base.new)
      @dataset_session.add_dataset(self, dataset)
    end
    
    def dataset_session
      @dataset_session
    end
  end
  
  def dataset_session
    self.class.dataset_session
  end
end