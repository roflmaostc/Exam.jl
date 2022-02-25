module Exam

using DataFrames
using CSV
using YAML
using Plots
using DataStructures

export read_exam
export read_grading
export evaluate

 # for half points Float64 is exact!
const MyFixedPointNumber = Float64

include("bonus.jl")
include("plotting.jl")

"""
    get_grades(exam)

Get a list of all grades
"""
function get_grades(exam)
    grades = [elem["grade"] for elem in exam["grades"]]
end

"""
    read_exam(path)

Read the `.yml` file for the exam.
"""
function read_exam(path)
    YAML.load_file(path) 
end

"""

Read the `.csv` file with the results of the exam.
"""
function read_grading(path)
    CSV.read(path, DataFrame)#, types=Dict(1 =>String, 2=> Int, 3=> Bool, 4 => Float16))
end 

function calculate_total_points!(results, exam)
    ntasks = length(exam["tasks"])
    total_points = sum(eachcol(select(results, ncol(results) - ntasks + 1:ncol(results))))
    insertcols!(results, :total_points => total_points)
    return results
end


function calculate_grades!(results, exam)
    # sum up the task points
    total_points = results[:, :total_points]

    # calculate a grade according to the grading scheme
    grades = map(total_points) do p
        grade = MyFixedPointNumber(last(exam["grades"])["grade"])
        best_points = last(exam["grades"])["min_points"] 
        
        for g in exam["grades"]
            if p ≥ g["min_points"] && g["min_points"] ≥ best_points 
                grade = g["grade"]
                best_points = g["min_points"]
            end
        end
        grade
    end

    if exam["bonus"]["available"]
        if exam["bonus"]["system"] == "increment_grade"
            grades = increment_grade(grades, results[:, :bonus], exam)
        end
    end
    

    insertcols!(results, :grade => grades)
    return results
end

"""
    evaluate(results_path, exam_path; <kwargs>)


# Keywords and default values
* `histogram=true`: export grade histogram  
* `anonymize=false`: remove names and only print id


"""
function evaluate(results_path, exam_path;
                    histogram=true,
                    anonymize=false,
                    dump_results_CSV=true,
                )


    exam = read_exam(exam_path)
    results = read_grading(results_path)

    for i in 1:length(exam["grades"])
        exam["grades"][i]["grade"] = MyFixedPointNumber(exam["grades"][i]["grade"])
    end



    # calculate points and insert into dataframe
    calculate_total_points!(results, exam)
    # insert grades into table
    calculate_grades!(results, exam)

    # plot histogram
    if histogram
        grade_histogram(results, exam)
    end

    if anonymize
        select!(results, Not(:name)) 
    end


    if dump_results_CSV
        CSV.write("results_debug.csv", results)
    end

    return results 
end

end # module
