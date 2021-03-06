--Solar Gun Frame - Javelin
function c210001506.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--target and Equip
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c210001506.etg)
	e2:SetOperation(c210001506.eop)
	c:RegisterEffect(e2)
	--redirect
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e3:SetValue(LOCATION_REMOVED)
	e3:SetCondition(c210001506.tgc)
	c:RegisterEffect(e3)
	--attack gain
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetValue(3000)
	c:RegisterEffect(e4)
	--effect gain
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(210001506,0))
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetHintTiming(TIMING_BATTLE_START)
	e5:SetCondition(c210001506.tgcon)
	e5:SetTarget(c210001506.tgtg)
	e5:SetOperation(c210001506.tgop)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(c210001506.eftg)
	e6:SetLabelObject(e5)
	c:RegisterEffect(e6)
end
c210001506.listed_names={210001505}
function c210001506.dfilter(c)
	local cg=c:GetEquipGroup()
	return c:IsFaceup() and c:IsSetCard(0x1f69) and cg and cg:IsExists(Card.IsSetCard,1,nil,0x1f70)
end
function c210001506.etg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return end
	if chk==0 then return Duel.IsExistingTarget(c210001506.dfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,210001505) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local tc=Duel.SelectTarget(tp,c210001506.dfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c210001506.eop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		local eg=tc:GetEquipGroup()
		if eg and eg:IsExists(Card.IsSetCard,1,nil,0x1f70) then
			Duel.Destroy(eg:Filter(Card.IsSetCard,nil,0x1f70),REASON_EFFECT)
		end
		Duel.BreakEffect()
		if Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,210001505) then
			Duel.Equip(tp,c,tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetLabelObject(tc)
			e1:SetValue(c210001506.eqlimit)
			c:RegisterEffect(e1)
		end
	end
end
function c210001506.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c210001506.tgc(e,tp)
	return not Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandlerPlayer(),LOCATION_GRAVE,0,1,nil,210001505)
end
function c210001506.eftg(e,c)
	local ec=e:GetHandler():GetEquipTarget()
	return ec==c
end
function c210001506.tgcon()
	return Duel.GetCurrentPhase()==PHASE_BATTLE_START
end
function c210001506.tgf(c,g)
	return g:IsContains(c) and c:IsAbleToDeck()
end
function c210001506.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local cg=e:GetHandler():GetColumnGroup()
	if chk==0 then return Duel.IsExistingMatchingCard(c210001506.tgf,tp,0,LOCATION_ONFIELD,1,nil,cg) end
	local g=Duel.GetMatchingGroup(c210001506.tgf,tp,0,LOCATION_ONFIELD,nil,cg)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,0,0)
end
function c210001506.tgop(e,tp,eg,ep,ev,re,r,rp)
	local cg=e:GetHandler():GetColumnGroup()
	local g=Duel.GetMatchingGroup(c210001506.tgf,tp,0,LOCATION_ONFIELD,nil,cg)
	Duel.SendtoDeck(g,nil,REASON_EFFECT)
end