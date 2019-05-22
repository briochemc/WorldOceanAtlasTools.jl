@testset "Citations" begin
    product_years = [2009, 2013, 2018]
    @testset "WOA$(WOA.my_product_year(y))" for y in product_years
        tracers = ["t", "s", "I", "C", "o", "O", "A", "i", "p", "n"]
        @testset "$(WOA.my_varname(t))" for t in tracers
            citation_str = WOA.citation(y, t)
            @test citation_str isa String
            println("Citation for $(WOA.my_varname(t)) from WOA$(WOA.my_product_year(y))")
            println(citation_str * "\n")
        end
    end
end
