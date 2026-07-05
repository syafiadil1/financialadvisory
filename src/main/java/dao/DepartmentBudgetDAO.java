package dao;

import connection.DBConnection;
import model.DepartmentBudgetModel;
import util.ErrorUtil;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class DepartmentBudgetDAO {

    public List<DepartmentBudgetModel> getBudgetRowsForYear(int year, Integer departmentId) {
        List<DepartmentBudgetModel> rows = new ArrayList<>();
        Date startDate = getYearStart(year);
        Date endDate = getYearEnd(year);

        StringBuilder sql = new StringBuilder("""
                SELECT
                    d.departmentid,
                    d.name AS departmentname,
                    b.departmentbudgetid,
                    b.initialbudget,
                    b.remainingbudget,
                    b.datestart,
                    b.dateend,
                    b.isactivebudget AS isactivebudget,
                    NVL((
                        SELECT SUM(t.totalamount)
                        FROM transaction t
                        WHERE t.departmentid = d.departmentid
                          AND LOWER(t.transactiontype) = 'expense'
                          AND LOWER(t.status) = 'approved'
                          AND t.datetransaction BETWEEN ? AND ?
                    ), 0) AS usedbudget
                FROM department d
                LEFT JOIN departmentbudget b
                    ON b.departmentid = d.departmentid
                   AND b.datestart = ?
                   AND b.dateend = ?
                   AND b.isactivebudget = 1
                """);

        if (departmentId != null) {
            sql.append(" WHERE d.departmentid = ?");
        }

        sql.append(" ORDER BY d.name");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            ps.setDate(1, startDate);
            ps.setDate(2, endDate);
            ps.setDate(3, startDate);
            ps.setDate(4, endDate);
            if (departmentId != null) {
                ps.setInt(5, departmentId);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    rows.add(mapBudgetRow(rs, year, startDate, endDate));
                }
            }
        } catch (SQLException e) {
            ErrorUtil.log("DepartmentBudgetDAO.java", "getBudgetRowsForYear", e);
        }

        return rows;
    }

    public boolean upsertDepartmentBudget(int departmentId, int year, double initialBudget) {
        Date startDate = getYearStart(year);
        Date endDate = getYearEnd(year);
        double usedBudget = getUsedBudget(departmentId, startDate, endDate);
        double remainingBudget = initialBudget - usedBudget;

        Integer existingId = getExistingBudgetId(departmentId, startDate, endDate);
        if (existingId != null) {
            return updateBudget(existingId, initialBudget, remainingBudget);
        }

        return insertBudget(departmentId, initialBudget, remainingBudget, startDate, endDate);
    }

    public double getUsedBudget(int departmentId, Date startDate, Date endDate) {
        String sql = """
                SELECT NVL(SUM(totalamount), 0) AS usedbudget
                FROM transaction
                WHERE departmentid = ?
                  AND LOWER(transactiontype) = 'expense'
                  AND LOWER(status) = 'approved'
                  AND datetransaction BETWEEN ? AND ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            ps.setDate(2, startDate);
            ps.setDate(3, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("usedbudget");
                }
            }
        } catch (SQLException e) {
            ErrorUtil.log("DepartmentBudgetDAO.java", "getUsedBudget", e);
        }

        return 0.0;
    }

    private Integer getExistingBudgetId(int departmentId, Date startDate, Date endDate) {
        String sql = """
                SELECT departmentbudgetid
                FROM departmentbudget
                WHERE departmentid = ?
                  AND datestart = ?
                  AND dateend = ?
                FETCH FIRST 1 ROW ONLY
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            ps.setDate(2, startDate);
            ps.setDate(3, endDate);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("departmentbudgetid");
                }
            }
        } catch (SQLException e) {
            ErrorUtil.log("DepartmentBudgetDAO.java", "getExistingBudgetId", e);
        }

        return null;
    }

    private boolean updateBudget(int departmentBudgetId, double initialBudget, double remainingBudget) {
        String sql = """
                UPDATE departmentbudget
                SET initialbudget = ?,
                    remainingbudget = ?,
                    isactivebudget = 1
                WHERE departmentbudgetid = ?
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setDouble(1, initialBudget);
            ps.setDouble(2, remainingBudget);
            ps.setInt(3, departmentBudgetId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            ErrorUtil.log("DepartmentBudgetDAO.java", "updateBudget", e);
        }

        return false;
    }

    private boolean insertBudget(int departmentId,
                                 double initialBudget,
                                 double remainingBudget,
                                 Date startDate,
                                 Date endDate) {
        String sql = """
                INSERT INTO departmentbudget
                    (departmentid, initialbudget, remainingbudget, datestart, dateend, isactivebudget)
                VALUES (?, ?, ?, ?, ?, 1)
                """;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, departmentId);
            ps.setDouble(2, initialBudget);
            ps.setDouble(3, remainingBudget);
            ps.setDate(4, startDate);
            ps.setDate(5, endDate);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            ErrorUtil.log("DepartmentBudgetDAO.java", "insertBudget", e);
        }

        return false;
    }

    private DepartmentBudgetModel mapBudgetRow(ResultSet rs, int year, Date startDate, Date endDate)
            throws SQLException {
        DepartmentBudgetModel row = new DepartmentBudgetModel();
        row.setDepartmentId(rs.getInt("departmentid"));
        row.setDepartmentName(rs.getString("departmentname"));
        row.setBudgetYear(year);

        int budgetId = rs.getInt("departmentbudgetid");
        if (!rs.wasNull()) {
            row.setDepartmentBudgetId(budgetId);
        }

        double initialBudget = rs.getDouble("initialbudget");
        if (rs.wasNull()) {
            initialBudget = 0.0;
        }

        double usedBudget = rs.getDouble("usedbudget");
        row.setInitialBudget(initialBudget);
        row.setUsedBudget(usedBudget);
        row.setRemainingBudget(initialBudget - usedBudget);

        Date savedStart = rs.getDate("datestart");
        Date savedEnd = rs.getDate("dateend");
        row.setDateStart(savedStart != null ? savedStart : startDate);
        row.setDateEnd(savedEnd != null ? savedEnd : endDate);

        int activeBudget = rs.getInt("isactivebudget");
        row.setActiveBudget(!rs.wasNull() && activeBudget == 1);

        return row;
    }

    private Date getYearStart(int year) {
        return Date.valueOf(LocalDate.of(year, 1, 1));
    }

    private Date getYearEnd(int year) {
        return Date.valueOf(LocalDate.of(year, 12, 31));
    }
}
