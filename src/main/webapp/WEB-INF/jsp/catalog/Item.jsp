<%--

       Copyright 2010-2026 the original author or authors.

       Licensed under the Apache License, Version 2.0 (the "License");
       you may not use this file except in compliance with the License.
       You may obtain a copy of the License at

          https://www.apache.org/licenses/LICENSE-2.0

       Unless required by applicable law or agreed to in writing, software
       distributed under the License is distributed on an "AS IS" BASIS,
       WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       See the License for the specific language governing permissions and
       limitations under the License.

--%>
<%@ include file="../common/IncludeTop.jsp"%>

<div id="BackLink"><stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
	event="viewProduct">
	<stripes:param name="productId" value="${actionBean.product.productId}" />
	Return to ${actionBean.product.productId}
</stripes:link></div>

<div id="Catalog">

<table>
	<!-- Content below is the server-rendered fallback; replaced by fetch() once the
	     jpetstore-partial REST API responds. -->
	<tr>
		<td id="item-description">${actionBean.product.description}</td>
	</tr>
	<tr>
		<td><b id="item-id"> ${actionBean.item.itemId} </b></td>
	</tr>
	<tr>
		<td><b><font size="4" id="item-attributes"> ${actionBean.item.attribute1}
		${actionBean.item.attribute2} ${actionBean.item.attribute3}
		${actionBean.item.attribute4} ${actionBean.item.attribute5}
		${actionBean.product.name} </font></b></td>
	</tr>
	<tr>
		<td id="item-product-name">${actionBean.product.name}</td>
	</tr>
	<tr>
		<td id="item-stock"><c:if test="${actionBean.item.quantity <= 0}">
        Back ordered.
      </c:if> <c:if test="${actionBean.item.quantity > 0}">
      	${actionBean.item.quantity} in stock.
	  </c:if></td>
	</tr>
	<tr>
		<td id="item-price"><fmt:formatNumber value="${actionBean.item.listPrice}"
			pattern="$#,##0.00" /></td>
	</tr>

	<tr>
		<td><stripes:link class="Button"
			beanclass="org.mybatis.jpetstore.web.actions.CartActionBean"
			event="addItemToCart">
			<stripes:param name="workingItemId" value="${actionBean.item.itemId}" />
       	Add to Cart
       </stripes:link></td>
	</tr>
</table>

</div>

<script>
document.addEventListener('DOMContentLoaded', async () => {
	var apiBaseUrl = 'http://' + window.location.hostname + ':8080/api/catalog';
	var params = new URLSearchParams(window.location.search);
	var itemId = params.get('itemId') || '${actionBean.item.itemId}';

	function formatPrice(value) {
		return '$' + Number(value).toLocaleString('en-US', {
			minimumFractionDigits: 2,
			maximumFractionDigits: 2
		});
	}

	try {
		var response = await fetch(apiBaseUrl + '/items/' + encodeURIComponent(itemId));
		if (!response.ok) {
			throw new Error('API responded with HTTP ' + response.status);
		}
		var item = await response.json();
		var product = item.product || {};

		// Product descriptions contain markup (e.g. <image> tags), matching the
		// unescaped server-rendered output above.
		document.getElementById('item-description').innerHTML = product.description == null ? '' : product.description;
		document.getElementById('item-id').textContent = item.itemId;

		var attributes = [item.attribute1, item.attribute2, item.attribute3, item.attribute4, item.attribute5]
			.filter(function (a) { return a; }).join(' ');
		document.getElementById('item-attributes').textContent = (attributes ? attributes + ' ' : '') + (product.name || '');
		document.getElementById('item-product-name').textContent = product.name || '';
		document.getElementById('item-stock').textContent = item.quantity > 0
			? item.quantity + ' in stock.'
			: 'Back ordered.';
		document.getElementById('item-price').textContent = formatPrice(item.listPrice);

		var backLinkEl = document.querySelector('#BackLink a');
		if (backLinkEl && product.productId) {
			backLinkEl.href = 'Catalog.action?viewProduct=&productId=' + encodeURIComponent(product.productId);
			backLinkEl.textContent = 'Return to ' + product.productId;
		}
	} catch (error) {
		console.error('Failed to load item data from jpetstore-partial API, keeping server-rendered content:', error);
	}
});
</script>

<%@ include file="../common/IncludeBottom.jsp"%>
