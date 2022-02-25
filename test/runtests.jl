using Exam
using Test
using CSV
using Random
using DataFrames

function generate_data()
    open("exam_results.csv", "w") do io
        write(io, "name,id,bonus,1,2,3\n")
        for i = 1:20
           write(io, randstring('a':'z', 6), ",", string(rand(1:Int(1e12))), ",",string(rand((false, true))), ",", 
                     string(rand(0:5)), ",", string(rand(0:2)), ",", string(rand(0:10)), "\n")
        end
    end        
end



@testset  begin
    correct_results = CSV.read("test/simple_test_output.csv", DataFrame)
    results = evaluate("test/simple_results.csv", "test/simple_exam.yml")
    @test results == correct_results
    
    correct_results = CSV.read("test/simple_test_output_anonymous.csv", DataFrame)
    results = evaluate("test/simple_results.csv", "test/simple_exam.yml", anonymize=true)
    @test results == correct_results

end
