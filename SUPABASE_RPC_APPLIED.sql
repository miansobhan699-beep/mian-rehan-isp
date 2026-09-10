  window.supabaseResetMonthOnline=async function(month){
    if(!sb)throw new Error('Supabase is not connected.');
    const {data:{user},error:userError}=await sb.auth.getUser();
    if(userError||!user)throw new Error('Please login again.');
    const {data,error}=await sb.rpc('reset_month_payments',{p_month:month+'-01'});
    if(error)throw error;
    return data||{deleted:0,bills_reset:0};
  };
