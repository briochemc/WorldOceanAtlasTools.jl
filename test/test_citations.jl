@testset "Citations" begin
    product_years = [2009, 2013, 2018, 2023]
    @testset "WOA$(WOA.my_product_year(product_year))" for product_year in product_years
        tracers = ["t", "s", "I", "C", "o", "O", "A", "i", "p", "n"]
        @testset "$(WOA.my_varname(tracer))" for tracer in tracers
            citation_str = WOA.citation(tracer; product_year=product_year)
            @test citation_str isa String
            println("Citation for $(WOA.my_varname(tracer)) from WOA$(WOA.my_product_year(product_year))")
            println(citation_str * "\n")
        end
    end
end
