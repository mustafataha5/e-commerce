import React, { useEffect, useState } from 'react'
import Navbar from '../component/Navbar'
import axios from 'axios';
import { Box, Button, CircularProgress, Typography } from '@mui/material';
import AddIcon from '@mui/icons-material/Add';
import { Grid } from 'gridjs-react';
import { html } from 'gridjs';
import 'gridjs/dist/theme/mermaid.css';
// import { toast } from 'react-toastify';
// import 'react-toastify/dist/ReactToastify.css';


const UsersPage = ({getUser=()=>{}}) => {

  const [users,setUsers] = useState([]) ; 
  const [loading,setLoading] = useState(true) ; 

  const getUsers =async () => {
    try{
      const response = await axios.get("http://localhost:8000/api/users",{withCredentials:true}) ; 
      //console.log(response.data.users) ; 
      setUsers(response.data.users)
    }
    catch(err){
      console.log(err) ; 
    }
    finally{
      setLoading(false) ; 
    }
  } ; 

  useEffect(()=>{
    getUser() ; 
    getUsers() ; 
  },[]);

  const handleEdit = (id) => {
    // Implement edit logic here
    console.log(id," <<<<<  Edit it >>>>>")
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://localhost:8000/api/users/${id}`, { withCredentials: true });
      setOrders(orders.filter((order) => order._id !== id));
      alert('Order deleted successfully');
    } catch (error) {
      console.error('Error deleting order:', error);
      alert('Failed to delete order');
    }
  };


  const formatDataForGrid =()=>{
    return users.map((user,index)=>{
      return [
        index+1,
        user.email,
        user.role,
        user.status,
        user._id , 
      ]
    });
  }
  
  const formatActions = (id,index) => {
    return html(`
      <button style="border: none; background: none; color: blue; cursor: pointer;" onclick="editItem('${id}','${index}')">
        Edit
      </button>
      <button style="border: none; background: none; color: red; cursor: pointer;" onclick="deleteItem('${id}','${index}')">
        Delete
      </button>
    `);
  };
    // Attach functions to window to use in HTML strings
    window.editItem = handleEdit;
    window.deleteItem = handleDelete;

  return (
    <div>
        <Navbar index={4}/>
        {loading ?  (
        <Box display="flex" justifyContent="center" alignItems="center" height="60vh">
          <CircularProgress />
        </Box>
      ):
      (
        <Box m={5} display="flex" flexDirection="column" alignItems="center">
          <Typography variant="h4" gutterBottom>Users Table</Typography>
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            //onClick={handleAdd}
            sx={{ mb: 3 }}
          >
            Add New User
          </Button>
          <Grid
            data={formatDataForGrid()}
            columns={[
              { name: '#', align: 'center' },
              { name: 'Email', align: 'center' },
              { name: 'Role', align: 'center' },
              { name: 'Status', align: 'center' },
              { name: 'Actions', align: 'center',
                formatter: (_, row) => {
                  const id = row.cells[4].data;
                  return formatActions(id,row._cells[0].data-1) ;
                },
               }
            ]}
            pagination={{ limit: 20 }}
            search={true}
            sort={true}
            style={{
              table: { border: '1px solid #e0e0e0' },
              th: { backgroundColor: '#f5f5f5', fontWeight: 'bold' },
            }}
          />
        </Box>
      ) 
      }
    </div>
  )
}

export default UsersPage
