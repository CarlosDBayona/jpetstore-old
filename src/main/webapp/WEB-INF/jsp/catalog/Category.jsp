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
	beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean">
	Return to Main Menu</stripes:link></div>

<div id="Catalog">

<h2 id="category-title">${actionBean.category.name}</h2>

<table>
	<thead>
	<tr>
		<th>Product ID</th>
		<th>Name</th>
	</tr>
	</thead>
	<tbody id="product-list-body">
		<!-- Rows below are the server-rendered fallback; replaced by fetch() once the
		     jpetstore-partial REST API (Issues #1 and #2) responds. -->
		<c:forEach var="product" items="${actionBean.productList}">
			<tr>
				<td><stripes:link
					beanclass="org.mybatis.jpetstore.web.actions.CatalogActionBean"
					event="viewProduct">
					<stripes:param name="productId" value="${product.productId}" />
					${product.productId}
				</stripes:link></td>
				<td>${product.name}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>

</div>

<script>
document.addEventListener('DOMContentLoaded', async () => {
	var apiBaseUrl = 'http://' + window.location.hostname + ':8080/api/catalog';
	var params = new URLSearchParams(window.location.search);
	var categoryId = params.get('categoryId') || '${actionBean.category.categoryId}';
	var titleEl = document.getElementById('category-title');
	var tbody = document.getElementById('product-list-body');

	function escapeHtml(value) {
		var div = document.createElement('div');
		div.textContent = value == null ? '' : String(value);
		return div.innerHTML;
	}

	try {
		var responses = await Promise.all([
			fetch(apiBaseUrl + '/categories'),
			fetch(apiBaseUrl + '/categories/' + encodeURIComponent(categoryId) + '/products')
		]);
		var categories = await responses[0].json();
		var products = await responses[1].json();

		var category = categories.find(function (c) { return c.categoryId === categoryId; });
		titleEl.textContent = category ? category.name : categoryId;

		tbody.innerHTML = products.map(function (product) {
			var safeProductId = escapeHtml(product.productId);
			return '<tr>'
				+ '<td><a href="Catalog.action?viewProduct=&productId=' + encodeURIComponent(product.productId) + '">' + safeProductId + '</a></td>'
				+ '<td>' + escapeHtml(product.name) + '</td>'
				+ '</tr>';
		}).join('');
	} catch (error) {
		console.error('Failed to load catalog data from jpetstore-partial API, keeping server-rendered rows:', error);
	}
});
</script>

<%@ include file="../common/IncludeBottom.jsp"%>
