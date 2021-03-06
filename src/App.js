import { Switch, Route, Redirect } from 'react-router-dom';
import Header from './components/Header/Header';
import PollCreate from './pages/PollCreate/PollCreate';
import PollVote from './pages/PollVote/PollVote';
import PollResult from './pages/PollResult/PollResult';
import PollReset from './pages/PollReset/PollReset';
import './App.css';

function App() {
  return (
    <div className="App">
      <Header />

      <Switch>
        <Route exact path="/" render={() => <Redirect to="/polls/vote" />} />

        <Route path="/polls/new" render={() => <PollCreate />} />
        
        <Route exact path="/polls/vote" render={() => <PollVote />} />

        <Route path="/polls/result" render={() => <PollResult />} />

        <Route path="/polls/reset" render={() => <PollReset />} />
      </Switch>
    </div>
  );
}

export default App;
