alter system alter configuration ('xsengine.ini','DATABASE','TST') set ('httpserver','embedded') = 'true' with reconfigure;
ALTER SYSTEM STOP DATABASE TST;


