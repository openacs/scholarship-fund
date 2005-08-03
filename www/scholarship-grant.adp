<master>
  <property name="title">Grant Scholarship</property>
  <property name="context">{Grant Scholarship}</property>

  <if @users:rowcount@ defined>
    <h3>Detailed search results:</h3>
    <listtemplate name="users"></listtemplate>
    <p />
  </if>

  <formtemplate id="grant"></formtemplate>