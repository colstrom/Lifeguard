class Lifeguard
  def initialize *lambdas
    @lambdas = lambdas
    @methods = self.create_hash
    
  end

  def create_hash
    hash = {}
    @symbols = []
    @lambdas.each_with_index do |lambda, i|
      hash[:"#{i}"] = lambda
      @symbols << :"#{i}"
    end
    hash
  end

  def monitor
    threads = []
    @lambdas.each_with_index do |lambda, i|
      threads << Thread.new {@methods[@symbols[i]].call}
    end

    # Reviver
    threads << Thread.new do
      lives = Array.new(threads.length) { |t| threads[t].status }
      loop do
        sleep(1)
        # p lives.map.with_index { |l, i| threads[i].status }
        threads.each_with_index do |thread, i|
          if thread.status != "run" && thread.status != "sleep"
            p "attempting to revive #{ @symbols[i] } #{i}"
            threads[i] = Thread.new { @methods[@symbols[i]].call }
            p "revived #{ @symbols[i] } #{i}"
          end
        end
      end
    end
    threads.each(&:join)
  end
end

# Example of usage: 
# l = Lifeguard.new(
#   lambda { 3.times do sleep(1); p '0th lambda' end },
#   lambda { 6.times do sleep(1); p '1st lambda' end },
#   lambda { 8.times do sleep(1); p '2nd lambda' end },
#   )

# l.monitor
