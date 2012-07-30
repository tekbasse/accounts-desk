-- accounts-desk-create.sql
--
-- @porting by Dekka Corp.
-- @copyright Copyright (c) 1999 - 2005, DWS Systems Inc.
-- @license GNU GENERAL PUBLIC LICENSE, Version 2, June 1991
-- @cvs-id



CREATE FUNCTION qad_avgcost(int) RETURNS FLOAT AS '

DECLARE

v_cost float;
v_qty float;
v_parts_id alias for $1;

BEGIN

  SELECT INTO v_cost, v_qty SUM(i.sellprice * i.qty), SUM(i.qty)
  FROM qar_invoice i
  JOIN qap_ap a ON (a.id = i.trans_id)
  WHERE i.parts_id = v_parts_id;

  IF NOT v_qty IS NULL THEN
    v_cost := v_cost/v_qty;
  END IF;

  IF v_cost IS NULL THEN
    v_cost := 0;
  END IF;

RETURN v_cost;

END;
' language 'plpgsql';
-- end function


-- following requires both AR and AP packages installed

CREATE TRIGGER qar_del_recurring AFTER DELETE ON qap_ap FOR EACH ROW EXECUTE PROCEDURE qar_del_recurring();
