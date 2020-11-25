using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using AI.Fuzzy.Library;
using System.Collections.Generic;

public partial class UserDefinedFunctions
{

    [SqlFunction(DataAccess = DataAccessKind.Read)]
    [return: SqlFacet(Precision = 10, Scale = 2)]
    public static SqlDecimal GetFuzzyScore(int id_plan)
    {
        Dictionary<int, double> query_results = new Dictionary<int, double>();
        SqlConnection conn = new SqlConnection();
        conn.ConnectionString = "Context Connection=true";

        SqlCommand cmd = new SqlCommand();
        cmd.Connection = conn;
        cmd.CommandText = @"
            SELECT	id_grupo, 
		            COUNT(*) AS InputScore
            FROM	PlanDet d
		            JOIN [Control] c ON d.id_control = c.Id 
            WHERE	id_plancab = @id_plan
		            AND d.aceptable = 1
            GROUP BY c.id_grupo";
        conn.Open();
        
        SqlParameter param_id_plan = cmd.Parameters.Add("@id_plan", SqlDbType.Int);
        param_id_plan.Value = id_plan;

        // Leo los resultados
        using (SqlDataReader reader = cmd.ExecuteReader())
        {
            while (reader.Read())
            {
                query_results.Add((int)reader.GetInt32(0), (int)reader.GetInt32(1));
            }
        }
        
        var fsScore = NuevoSistema();

        FuzzyVariable fvBpm = fsScore.InputByName("bpm");
        FuzzyVariable fvPoes = fsScore.InputByName("poes");
        FuzzyVariable fvHaccp = fsScore.InputByName("haccp");
        FuzzyVariable fvScore = fsScore.OutputByName("score");

        Dictionary<FuzzyVariable, double> inputValues = new Dictionary<FuzzyVariable, double>();

        inputValues.Add(fvBpm, query_results[1]);
        inputValues.Add(fvPoes, query_results[2]);
        inputValues.Add(fvHaccp, query_results[3]);

        //
        // Calculo el resultado
        //
        Dictionary<FuzzyVariable, double> result = fsScore.Calculate(inputValues);
        conn.Close();
        return new SqlDecimal(result[fvScore]);
    }

    public static MamdaniFuzzySystem NuevoSistema()
    {
        // Nuevo sistema difuso 
        MamdaniFuzzySystem fsScores = new MamdaniFuzzySystem();

        // Creo las variables de entrada con sus funciones de pertenencia
        FuzzyVariable fvBpm = new FuzzyVariable("bpm", 0.0, 16.0);
        fvBpm.Terms.Add( new FuzzyTerm("na", new TrapezoidMembershipFunction(0.0,0.0,6.0,10.0)));
        fvBpm.Terms.Add(new FuzzyTerm("a", new TrapezoidMembershipFunction(6.0, 10.0, 16.0, 16.0)));
        fsScores.Input.Add(fvBpm);

        FuzzyVariable fvPoes = new FuzzyVariable("poes", 0.0, 12.0);
        fvPoes.Terms.Add(new FuzzyTerm("na", new TrapezoidMembershipFunction(0.0, 0.0, 5.0, 7.0)));
        fvPoes.Terms.Add(new FuzzyTerm("a", new TrapezoidMembershipFunction(5.0, 7.0, 11.0, 11.0)));
        fsScores.Input.Add(fvPoes);

        FuzzyVariable fvHaccp = new FuzzyVariable("haccp", 0.0, 10.0);
        fvHaccp.Terms.Add(new FuzzyTerm("na", new TrapezoidMembershipFunction(0.0, 0.0, 6.0, 8.0)));
        fvHaccp.Terms.Add(new FuzzyTerm("a", new TrapezoidMembershipFunction(6.0, 8.0, 10.0, 10.0)));
        fsScores.Input.Add(fvHaccp);

        // Ahora la variable de salida
        FuzzyVariable fvScore = new FuzzyVariable("score", 0.0, 9.0);
        fvScore.Terms.Add(new FuzzyTerm("muy_malo", new TrapezoidMembershipFunction(0.0, 0.0, 1.0, 3.0)));
        fvScore.Terms.Add(new FuzzyTerm("malo", new TrapezoidMembershipFunction(1.0, 3.0, 4.0, 6.0)));
        fvScore.Terms.Add(new FuzzyTerm("bueno", new TrapezoidMembershipFunction(4.0, 6.0, 7.0, 9.0)));
        fvScore.Terms.Add(new FuzzyTerm("muy_bueno", new TrapezoidMembershipFunction(7.0, 9.0, 9.0, 9.0)));
        fsScores.Output.Add(fvScore);

        // Creo las reglas
        try
        {
            MamdaniFuzzyRule rule1 = fsScores.ParseRule("if (bpm is na )  and (poes is na) and (haccp is na) then score is muy_malo");
            MamdaniFuzzyRule rule2 = fsScores.ParseRule("if (bpm is na )  and (poes is na) and (haccp is a) then score is malo");
            MamdaniFuzzyRule rule3 = fsScores.ParseRule("if (bpm is na )  and (poes is a) and (haccp is na) then score is malo");
            MamdaniFuzzyRule rule4 = fsScores.ParseRule("if (bpm is na )  and (poes is a) and (haccp is a) then score is bueno");
            MamdaniFuzzyRule rule5 = fsScores.ParseRule("if (bpm is a )  and (poes is na) and (haccp is na) then score is malo");
            MamdaniFuzzyRule rule6 = fsScores.ParseRule("if (bpm is a )  and (poes is na) and (haccp is a) then score is bueno");
            MamdaniFuzzyRule rule7 = fsScores.ParseRule("if (bpm is a )  and (poes is a) and (haccp is na) then score is bueno");
            MamdaniFuzzyRule rule8 = fsScores.ParseRule("if (bpm is a )  and (poes is a) and (haccp is a) then score is muy_bueno");

            fsScores.Rules.Add(rule1);
            fsScores.Rules.Add(rule2);
            fsScores.Rules.Add(rule3);
            fsScores.Rules.Add(rule4);
            fsScores.Rules.Add(rule5);
            fsScores.Rules.Add(rule6);
            fsScores.Rules.Add(rule7);
            fsScores.Rules.Add(rule8);

        }
        catch (Exception ex)
        {
            return null;
        }

        return fsScores;
    }
 
}
