using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;

namespace HimVeda.Classes
{
    public static class DBHelper
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["HimVedaDB"].ConnectionString;

        /// <summary>
        /// Executes a query that returns a DataTable (SELECT).
        /// </summary>
        public static DataTable ExecuteQuery(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    using (SqlDataAdapter sda = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        try
                        {
                            conn.Open();
                            sda.Fill(dt);
                        }
                        catch (Exception ex)
                        {
                            // In a real app, log the exception.
                            throw new Exception("Database Execution Error: " + ex.Message, ex);
                        }
                        return dt;
                    }
                }
            }
        }

        /// <summary>
        /// Executes a non-query command (INSERT, UPDATE, DELETE).
        /// Returns the number of affected rows.
        /// </summary>
        public static int ExecuteNonQuery(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    try
                    {
                        conn.Open();
                        return cmd.ExecuteNonQuery();
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Database Execution Error: " + ex.Message, ex);
                    }
                }
            }
        }

        /// <summary>
        /// Executes a query and returns a single value (e.g., SELECT COUNT).
        /// </summary>
        public static object ExecuteScalar(string query, SqlParameter[] parameters = null)
        {
            using (SqlConnection conn = new SqlConnection(ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }

                    try
                    {
                        conn.Open();
                        return cmd.ExecuteScalar();
                    }
                    catch (Exception ex)
                    {
                        throw new Exception("Database Execution Error: " + ex.Message, ex);
                    }
                }
            }
        }
    }
}
