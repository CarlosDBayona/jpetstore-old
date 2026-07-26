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

<jsp:useBean id="catalog"
	class="org.mybatis.jpetstore.web.actions.CatalogActionBean" />

<div id="BackLink"><stripes:link
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
	event="viewCategory">
	<stripes:param name="categoryId"
		value="${actionBean.product.categoryId}" />
	Return to ${actionBean.product.categoryId}
</stripes:link></div>

<div id="Catalog">

<h2 id="product-title">${actionBean.product.name}</h2>

<table>
	<thead>
	<tr>
		<th>Item ID</th>
		<th>Product ID</th>
		<th>Description</th>
		<th>List Price</th>
		<th>&nbsp;</th>
	</tr>
	</thead>
	<tbody id="item-list-body">
	<!-- Rows below are the server-rendered fallback; replaced by fetch() once the
	     jpetstore-partial REST API (Issue #4) responds. -->
	<c:forEach var="item" items="${actionBean.itemList}">
		<tr>
			<td><stripes:link
				beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
				event="viewItem">
				<stripes:param name="itemId" value="${item.itemId}" />
				${item.itemId}
			</stripes:link></td>
			<td>${item.product.productId}</td>
			<td>${item.attribute1} ${item.attribute2} ${item.attribute3}
			${item.attribute4} ${item.attribute5} ${actionBean.product.name}</td>
			<td><fmt:formatNumber value="${item.listPrice}"
				pattern="$#,##0.00" /></td>
			<td><stripes:link class="Button"
				beanclass="org.mybatis.jpetstore.web.actions.CartActionBean"
				event="addItemToCart">
				<stripes:param name="workingItemId" value="${item.itemId}" />
        	Add to Cart
        </stripes:link></td>
		</tr>
	</c:forEach>
	<tr>
		<td>
		</td>
	</tr>
	</tbody>
</table>

</div>

<script>
document.addEventListener('DOMContentLoaded', async () => {
	var apiBaseUrl = 'http://' + window.location.hostname + ':8080/api/catalog';
	var params = new URLSearchParams(window.location.search);
	var productId = params.get('productId') || '${actionBean.product.productId}';
	var productName = document.getElementById('product-title').textContent;
	var tbody = document.getElementById('item-list-body');

	function escapeHtml(value) {
		var div = document.createElement('div');
		div.textContent = value == null ? '' : String(value);
		return div.innerHTML;
	}

	function formatPrice(value) {
		return '$' + Number(value).toFixed(2);
	}

	function describeItem(item) {
		var attrs = [item.attribute1, item.attribute2, item.attribute3, item.attribute4, item.attribute5]
			.filter(function (attr) { return attr; });
		attrs.push(productName);
		return attrs.join(' ');
	}

	try {
		var response = await fetch(apiBaseUrl + '/products/' + encodeURIComponent(productId) + '/items');
		var items = await response.json();

		tbody.innerHTML = items.map(function (item) {
			var safeItemId = escapeHtml(item.itemId);
			return '<tr>'
				+ '<td><a href="Catalog.action?viewItem=&itemId=' + encodeURIComponent(item.itemId) + '">' + safeItemId + '</a></td>'
				+ '<td>' + escapeHtml(item.productId) + '</td>'
				+ '<td>' + escapeHtml(describeItem(item)) + '</td>'
				+ '<td>' + escapeHtml(formatPrice(item.listPrice)) + '</td>'
				+ '<td><a class="Button" href="Cart.action?addItemToCart=&workingItemId=' + encodeURIComponent(item.itemId) + '">Add to Cart</a></td>'
				+ '</tr>';
		}).join('');
	} catch (error) {
		console.error('Failed to load item data from jpetstore-partial API, keeping server-rendered rows:', error);
	}
});
</script>

<%@ include file="../common/IncludeBottom.jsp"%>
