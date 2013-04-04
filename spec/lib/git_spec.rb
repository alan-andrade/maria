require 'spec_helper'

describe Git do
  it{ should respond_to(:username) }

  describe Git::Persistence do
    let :klass do
      Class.new { include Git::Persistence }
    end

    subject{ klass.new }

    it{ should_not be_persisted }
  end


  describe Git::Attributes do

    let :klass do
      Class.new { include Git::Attributes }
    end

    subject{ klass.new }

    it{ should respond_to(:body) }
    it{ should respond_to(:name) }

  end

end
