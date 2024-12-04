import React, { useEffect, useState } from 'react';
import Navbar from '../component/Navbar';
import axios from 'axios';
import { Box, Button, CircularProgress, Typography } from '@mui/material';
import { Grid } from 'gridjs-react';
import { html } from 'gridjs';
import 'gridjs/dist/theme/mermaid.css';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { useNavigate } from 'react-router-dom';
import AddIcon from '@mui/icons-material/Add';

const ItemsPage = ({ user, getUser = () => {}, setData }) => {
  const [items, setItems] = useState([]);
  const [categories, setCategories] = useState([]);
  const [loading, setLoading] = useState(true);
  const navigate = useNavigate();

  const getItems = async () => {
    try {
      const response = await axios.get('http://localhost:8000/api/items', { withCredentials: true });
      setItems(response.data.items);
      //setLoading(false);
    } catch (error) {
      console.error('Error fetching items:', error);
      setLoading(false);
    }
  };

  const getCategories = async () => {
    try {
      const response = await axios.get('http://localhost:8000/api/categories', { withCredentials: true });
      setCategories(response.data.categories);
      setLoading(false);
    } catch (error) {
      console.error('Error ', error);
      setLoading(false);
    }
  };

  useEffect(() => {
    getUser();
    getItems();
    getCategories() ; 
  }, []);

  const handleAdd = () => {
    navigate(`/admin/items/new`);
  };

  const handleEdit = (id) => {
    const item = items.find((item) => item._id === id);
    if (item) {
      setData([
        item.categoryId,
        item.name,
        item.name_ar,
        item.price,
        item.description,
        item.availableNum,
        item.imageUrl,
      ]);
      navigate(`/admin/items/${id}`);
    }
  };

  const handleDelete = async (id) => {
    try {
      await axios.delete(`http://localhost:8000/api/items/${id}`, { withCredentials: true });
      toast.success('Item deleted successfully');
      setItems(items.filter((item) => item._id !== id));
    } catch (error) {
      console.error('Error deleting item:', error);
      toast.error('Failed to delete item');
    }
  };

  // Format data for the grid
  const formatDataForGrid = () => {
    return items.map((item, index) => {
      const category = categories.find(category => category._id === item.categoryId);
      return [
        index + 1,
        item.name,
        item.price,
        item.availableNum,
        category ? category.name_en : 'No Category',
        item.imageUrl,
        item._id,
       
      ];
    });
  };
  

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
      <Navbar index={2} />
      {loading ? (
        <Box display="flex" justifyContent="center" alignItems="center" height="60vh">
          <CircularProgress />
        </Box>
      ) : (
        <Box m={5} display="flex" flexDirection="column" alignItems="center">
          <Typography variant="h4" gutterBottom>Items Table</Typography>
          <Button
            variant="contained"
            color="primary"
            startIcon={<AddIcon />}
            onClick={handleAdd}
            sx={{ mb: 3 }}
          >
            Add New Item
          </Button>
          <Grid
            data={formatDataForGrid()}
            columns={[
              { name: '#', align: 'center' },
              { name: 'Name'
                , align: 'center'
              , formatter: (_,row) =>{
                const id = row.cells[6].data;
                return html(`<a href="/admin/items/${id}/show">${row.cells[1].data} </a>`);

               },
              } ,
              { name: 'Price', align: 'center' },
              { name: 'Available Number', align: 'center' },

              { name: 'category', align: 'center' },
              {
                name: 'Image',
                align: 'center',
                formatter: (cell) => html(`<img src="${cell}" alt="item" style="max-width: 50px; height: auto;" />`),
              },

              {
                name: 'Action',
                align: 'center',
                formatter: (_, row) => {
                  const id = row.cells[6].data;
                  return formatActions(id,row._cells[0].data-1) ;
                },
              },
              
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
      )}
    </div>
  );
};

export default ItemsPage;
