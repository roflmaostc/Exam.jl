function grade_histogram(results, exam)
    grades = get_grades(exam) 
    counter_grades = counter(results[:, :grade])
    occ = [g ∈ keys(counter_grades) ? counter_grades[g] : 0 for g in grades]

    p = bar(grades, occ) 
    ylabel!("Occurence")
    xlabel!("Grade")
    title!("Grade Distribution - " * exam["title"])

    savefig(p, exam["title"] * ".png")
end
