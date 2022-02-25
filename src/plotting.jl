"""
    grade_histogram(results, exam)
"""
function grade_histogram(results, exam)
    grades = get_grades(exam) 

    passed = [g["passed"] ? :green : :red for g in exam["grades"]]

    counter_grades = counter(results[:, :grade])
    occ = [g ∈ keys(counter_grades) ? counter_grades[g] : 0 for g in grades]



    p = bar(occ, xticks=(1:length(grades), grades), color=passed, legend=false, dpi=300) 
    ylabel!("Occurence")
    xlabel!("Grade")
    title!("Grade Distribution - " * exam["title"])

    savefig(p, exam["title"] * "_grade_histogram" * ".png")
end
