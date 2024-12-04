import { useState } from 'react'

// import './App.css'
import { Navigate, Route, Routes, useNavigate } from 'react-router-dom'
import Login from './views/Login'
import Page403 from './views/Page403'
import Page404 from './views/Page404'
import Page401 from './views/Page401'
import MainPage from './views/MainPage'

import CategoriesPage from './views/CategoriesPage'

import ItemsPage from './views/ItemsPage'
import OrdersPage from './views/OrdersPage'
import UsersPage from './views/UsersPage'
import axios from 'axios'
import CategoryForm from './component/CategoryForm'
import { ToastContainer } from 'react-toastify'
import ItemForm from './component/ItemForm'
import ImageUpload from './component/ImageUpload'
import ItemShow from './component/ItemShow'
import OrderForm from './component/OrderForm'

function App() {

  const [user, setUser] = useState();

  const [data, setData] = useState([]);

  const navigate = useNavigate();
  const getUser = async () => {
    await axios.get('http://localhost:8000/api/checkauth', { withCredentials: true })
      .then((response) => {
        //console.log("inside", response.data.user)
        if (response.data.user.role !== "_admin") {
          navigate('/403')
        }
        setUser(response.data.user);
        // console.log(">>>>>>>>>>>",response.data.user)
      })
      .catch(error => {
        console.error('Error checking authentication', error);
        navigate('/401'); // Redirect to login if not authenticated
      })
  }

  return (
    <>


      <Routes>

        <Route path="/" element={<Navigate to="/login" />} />

        <Route path="/admin/Main" element={<MainPage user={user} getUser={getUser} />} />
        <Route path="/admin/categories" element={<CategoriesPage user={user} getUser={getUser} setData={setData} />} />
        <Route path="/admin/categories/new" element={<CategoryForm getUser={getUser} />} />
        <Route path="/admin/categories/:id" element={<CategoryForm
          initialName_en={data[0]}
          initialName_ar={data[1]}
          isUpdate={true}
          getUser={getUser} />} />

        <Route path="/admin/items" element={<ItemsPage user={user} getUser={getUser} setData={setData} />} />
        <Route path="/admin/items/new" element={<ItemForm getUser={getUser} />} />
        <Route path="/admin/items/:id" element={<ItemForm
          initialCategoryId={data[0]}
          initialName={data[1]}
          initialNameAr={data[2]}
          initialPrice={data[3]}
          initialDescription={data[4]}
          initialAvailableNum={data[5]}
          initialImageUrl={data[6]}
          isUpdate={true}
          getUser={getUser} />} />
        <Route path="/admin/items/:id/show" element={<ItemShow
          getUser={getUser} setData={setData} />} />

        <Route path="/admin/orders" element={<OrdersPage getUser={getUser} setData={setData} />} />
        <Route path="/admin/orders/new" element={<OrderForm user={user} getUser={getUser} />} />
        <Route path="/admin/orders/:id" element={<OrderForm
          isUpdate={true}
          user={user}
          getUser={getUser} />} />
          
        <Route path="/admin/users" element={<UsersPage getUser={getUser} />} />
        {/* <Route path="/admin/imageupload" element={<ImageUpload  getUser={getUser} />} /> */}
        <Route path="/login" element={<Login />} />
        <Route path="/403" element={<Page403 />} />
        <Route path="/401" element={<Page401 />} />
        <Route path="*" element={<Page404 />} />
      </Routes>
      <ToastContainer position="top-center" autoClose={3000} hideProgressBar={false} />
    </>
  )
}

export default App
